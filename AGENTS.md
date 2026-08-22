# Repository Guidelines

## Project Structure & Module Organization

CCNUthesis is a XeLaTeX/LuaLaTeX thesis-template repository. Core class and bibliography styles live in `source/` (`CCNUthesis.cls` and `gb7714-CCNU*.bbx/.cbx`). The canonical working example is under `test/test-basic/`, with `front/`, `body/`, and `back/` chapter content. Additional focused TeX checks are in `test/`. User documentation and its source are in `docs/user-guide/`; supporting notes and references are in `docs/`. Reusable images and documents belong in `assets/`. Build and release helpers are in `scripts/`. Treat `dist/` as packaged output and `legacy/` as archival material.

## Build, Test, and Development Commands

Install a TeX distribution with XeLaTeX, `latexmk`, and Biber.

```sh
make test                                          # compile all configured fixtures
make test-parallel                                 # compile fixtures concurrently
make docs                                          # build the user guide
make package VERSION=1.4.7                        # validated non-interactive release
make release-check VERSION=1.4.7                  # validate release arguments only
```

The release builder edits version metadata and creates `release/`; use it only for an intentional release. `scripts/test.sh` also accepts `-p`, `-r`, `--report-format`, and `--no-clean`.

## Coding Style & Naming Conventions

Keep all TeX source UTF-8 encoded and compatible with XeLaTeX or LuaLaTeX. Follow the existing expl3 conventions in `source/`: two-space indentation, descriptive `snake_case` control-sequence names, and `__ccnu_`/`g__ccnu_` prefixes for internal/global variables. Preserve the established lowercase, hyphenated names for bibliography style files. Shell scripts should remain POSIX/Bash-readable and executable. Make small, consistent edits and avoid committing generated auxiliaries.

## Testing Guidelines

Tests are compile-based rather than unit-test based. Add focused `.tex` cases under `test/` and place complete document fixtures in a descriptive subdirectory (for example, `test/test-basic/`). A passing test must compile with `latexmk -xelatex` and produce the expected PDF; inspect warnings when changing layout or bibliography behavior.

## Commit & Pull Request Guidelines

History mixes concise Chinese summaries with Conventional Commit-style prefixes such as `feat:`, `fix:`, and `chore:`. Use a short imperative subject, optionally prefixed by the affected area, and keep unrelated changes in separate commits. Pull requests should explain the template behavior changed, identify affected files/options, include reproducible compile/test commands, and attach before/after PDF screenshots when layout changes. Update `CHANGELOG.md` for user-visible fixes or features.

## Configuration & Generated Files

Do not commit personal thesis data, payment/service materials, or private documents. Keep build outputs and LaTeX auxiliary files out of commits; `.gitignore` already covers common extensions. Review path changes in `CCNUthesis.cls` and `main.tex` carefully before packaging a release.
