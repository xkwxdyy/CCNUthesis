#!/usr/bin/env bash
set -Eeuo pipefail

# Compile the repository's supported TeX fixtures. Every configured fixture is
# required: a missing directory or source file is a failure, never a skip.

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARALLEL=false
GENERATE_REPORT=false
REPORT_FORMAT="text"
VERBOSE=false
CLEAN_AFTER=true
TEST_TIMEOUT="${CCNU_TEST_TIMEOUT:-120}"

usage() {
  cat <<'EOF'
Usage: scripts/test.sh [options]

Options:
  -p, --parallel           Compile independent fixtures in parallel
  -r, --report             Write a report using --report-format
      --report-format FMT  text, markdown, or html (default: text)
  -v, --verbose            Print each compiler log on failure
      --no-clean            Keep LaTeX auxiliary files in fixture directories
  -h, --help               Show this help
EOF
}

while (($#)); do
  case "$1" in
    -p|--parallel) PARALLEL=true; shift ;;
    -r|--report) GENERATE_REPORT=true; shift ;;
    --report-format)
      (($# >= 2)) || { echo "--report-format requires a value" >&2; exit 2; }
      REPORT_FORMAT="$2"
      shift 2
      ;;
    -v|--verbose) VERBOSE=true; shift ;;
    --no-clean) CLEAN_AFTER=false; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

case "$REPORT_FORMAT" in
  text|markdown|md|html) ;;
  *) echo "Unsupported report format: $REPORT_FORMAT" >&2; exit 2 ;;
esac

if ! command -v latexmk >/dev/null 2>&1; then
  echo "latexmk is required but was not found on PATH" >&2
  exit 2
fi

TIMEOUT_CMD=()
if command -v timeout >/dev/null 2>&1; then
  TIMEOUT_CMD=(timeout "$TEST_TIMEOUT")
fi

RESULT_DIR="$(mktemp -d "${TMPDIR:-/tmp}/ccnu-test.XXXXXX")"
trap 'rm -rf "$RESULT_DIR"' EXIT

# name | working directory | TeX source | kind
TESTS=(
  "Basic Template|test/test-basic|main.tex|full"
  "Choices Test|test|choices-test.tex|quick"
  "Newtheorem Test|test|main-test-1-ccnunewtheorem.tex|quick"
)

run_case() {
  local index="$1"
  local name="$2"
  local relative_dir="$3"
  local tex_file="$4"
  local kind="$5"
  local work_dir="$BASE_DIR/$relative_dir"
  local result_file="$RESULT_DIR/$index.result"
  local log_file="$RESULT_DIR/$index.log"
  local start end duration stem cache_dir
  start="$(date +%s)"

  if [[ ! -d "$work_dir" ]]; then
    printf '%s\tFAIL\t0\tmissing directory: %s\n' "$name" "$relative_dir" > "$result_file"
    return 0
  fi
  if [[ ! -f "$work_dir/$tex_file" ]]; then
    printf '%s\tFAIL\t0\tmissing source: %s/%s\n' "$name" "$relative_dir" "$tex_file" > "$result_file"
    return 0
  fi

  if [[ "$CLEAN_AFTER" == true ]]; then
    (cd "$work_dir" && latexmk -c >/dev/null 2>&1) || true
  fi

  stem="${tex_file%.tex}"
  # Biber is a PAR-packed binary on macOS.  Give each parallel fixture an
  # isolated writable cache so PAR's lock file cannot deadlock independent
  # compilations in CI sandboxes where the user's home cache may be read-only.
  cache_dir="$RESULT_DIR/biber-cache-$index"
  mkdir -p "$cache_dir" "$RESULT_DIR/texmf-var" "$RESULT_DIR/texmf-config"
  if (
    cd "$work_dir"
    TEXINPUTS="$BASE_DIR/source:${TEXINPUTS:-}" \
      PAR_GLOBAL_TEMP="$cache_dir" PAR_GLOBAL_TMPDIR="$cache_dir" \
      TEXMFVAR="$RESULT_DIR/texmf-var" TEXMFCONFIG="$RESULT_DIR/texmf-config" \
      "${TIMEOUT_CMD[@]}" latexmk -xelatex -g -interaction=nonstopmode -halt-on-error "$tex_file"
  ) >"$log_file" 2>&1; then
    if [[ "$kind" == full && ! -s "$work_dir/$stem.pdf" ]]; then
      printf '%s\tFAIL\t0\tcompiler succeeded but PDF is missing\n' "$name" > "$result_file"
      return 0
    fi
    end="$(date +%s)"
    duration=$((end - start))
    printf '%s\tPASS\t%s\t%s\n' "$name" "$duration" "$log_file" > "$result_file"
  else
    end="$(date +%s)"
    duration=$((end - start))
    printf '%s\tFAIL\t%s\t%s\n' "$name" "$duration" "$log_file" > "$result_file"
  fi

  if [[ "$CLEAN_AFTER" == true ]]; then
    (cd "$work_dir" && latexmk -c >/dev/null 2>&1) || true
  fi
}

echo "CCNUthesis test runner"
echo "Fixtures: ${#TESTS[@]} | parallel: $PARALLEL | timeout: ${TEST_TIMEOUT}s"

index=0
for config in "${TESTS[@]}"; do
  IFS='|' read -r name relative_dir tex_file kind <<< "$config"
  if [[ "$PARALLEL" == true ]]; then
    run_case "$index" "$name" "$relative_dir" "$tex_file" "$kind" &
  else
    run_case "$index" "$name" "$relative_dir" "$tex_file" "$kind"
  fi
  index=$((index + 1))
done

if [[ "$PARALLEL" == true ]]; then
  wait || true
fi

total=0
passed=0
failed=0
report_rows=()
for result_file in "$RESULT_DIR"/*.result; do
  IFS=$'\t' read -r name result duration detail < "$result_file"
  total=$((total + 1))
  if [[ "$result" == PASS ]]; then
    passed=$((passed + 1))
  else
    failed=$((failed + 1))
  fi
  report_rows+=("$name|$result|$duration|$detail")
done

echo ""
echo "Total: $total | Passed: $passed | Failed: $failed"
for row in "${report_rows[@]}"; do
  IFS='|' read -r name result duration detail <<< "$row"
  if [[ "$result" == PASS ]]; then
    echo "PASS  $name (${duration}s)"
  else
    echo "FAIL  $name (${duration}s)"
    if [[ "$VERBOSE" == true && -f "$detail" ]]; then
      echo "      --- compiler log (tail) ---"
      tail -n 120 "$detail"
    elif [[ -f "$detail" ]]; then
      echo "      log: $detail"
    else
      echo "      $detail"
    fi
  fi
done

if [[ "$GENERATE_REPORT" == true && "$REPORT_FORMAT" != text ]]; then
  REPORT_FILE="$BASE_DIR/test-report-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "${REPORT_FILE}-logs"
  persistent_rows=()
  row_index=0
  for row in "${report_rows[@]}"; do
    IFS='|' read -r name result duration detail <<< "$row"
    if [[ -f "$detail" ]]; then
      persistent_detail="${REPORT_FILE}-logs/${row_index}.log"
      cp "$detail" "$persistent_detail"
      detail="$persistent_detail"
    fi
    persistent_rows+=("$name|$result|$duration|$detail")
    row_index=$((row_index + 1))
  done
  report_rows=("${persistent_rows[@]}")
  if [[ "$REPORT_FORMAT" == markdown || "$REPORT_FORMAT" == md ]]; then
    {
      echo "# CCNUthesis Test Report"
      echo
      echo "| Fixture | Result | Duration | Detail |"
      echo "|---|---|---:|---|"
      for row in "${report_rows[@]}"; do
        IFS='|' read -r name result duration detail <<< "$row"
        echo "| $name | $result | ${duration}s | $detail |"
      done
    } > "$REPORT_FILE.md"
    echo "Report: $REPORT_FILE.md"
  else
    {
      echo '<!doctype html><meta charset="utf-8"><title>CCNUthesis Test Report</title>'
      echo '<table><tr><th>Fixture</th><th>Result</th><th>Duration</th><th>Detail</th></tr>'
      for row in "${report_rows[@]}"; do
        IFS='|' read -r name result duration detail <<< "$row"
        printf '<tr><td>%s</td><td>%s</td><td>%ss</td><td>%s</td></tr>\n' "$name" "$result" "$duration" "$detail"
      done
      echo '</table>'
    } > "$REPORT_FILE.html"
    echo "Report: $REPORT_FILE.html"
  fi
fi

if ((failed > 0)); then
  exit 1
fi
