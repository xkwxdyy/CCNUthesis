#!/bin/bash
# Test script for CCNUthesis development
# Supports parallel testing and report generation

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
PARALLEL=false
GENERATE_REPORT=false
REPORT_FORMAT="text"
VERBOSE=false
CLEAN_AFTER=true
TEST_TIMEOUT=120

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--parallel)
            PARALLEL=true
            shift
            ;;
        -r|--report)
            GENERATE_REPORT=true
            shift
            ;;
        --report-format)
            REPORT_FORMAT="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        --no-clean)
            CLEAN_AFTER=false
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  -p, --parallel          Run tests in parallel"
            echo "  -r, --report           Generate test report"
            echo "  --report-format FORMAT  Report format (text|html|markdown)"
            echo "  -v, --verbose          Show detailed output"
            echo "  --no-clean             Don't clean auxiliary files after test"
            echo "  -h, --help             Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Base directory
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$BASE_DIR"

# Test results storage
declare -A test_results
declare -A test_times
declare -A test_logs

# Initialize test report
REPORT_FILE="$BASE_DIR/test-report-$(date +%Y%m%d-%H%M%S)"
REPORT_DATA=""

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     CCNUthesis Test Runner v2.0       ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

# Function to run a single test
run_test() {
    local test_name=$1
    local test_dir=$2
    local test_type=$3
    
    local start_time=$(date +%s)
    
    if [ "$VERBOSE" = true ]; then
        echo -e "${CYAN}Testing: $test_name${NC}"
        echo "  Directory: $test_dir"
        echo "  Type: $test_type"
    else
        echo -ne "${YELLOW}Testing $test_name...${NC}"
    fi
    
    # Check if test directory exists
    if [ ! -d "$test_dir" ]; then
        test_results["$test_name"]="SKIP"
        test_logs["$test_name"]="Test directory not found"
        if [ "$VERBOSE" = false ]; then
            echo -e " ${YELLOW}SKIPPED${NC} (directory not found)"
        fi
        return 2
    fi
    
    # Check if main.tex exists
    if [ ! -f "$test_dir/main.tex" ]; then
        test_results["$test_name"]="SKIP"
        test_logs["$test_name"]="main.tex not found"
        if [ "$VERBOSE" = false ]; then
            echo -e " ${YELLOW}SKIPPED${NC} (main.tex not found)"
        fi
        return 2
    fi
    
    cd "$test_dir"
    
    # Clean previous builds
    if [ "$CLEAN_AFTER" = true ]; then
        latexmk -c >/dev/null 2>&1
    fi
    
    # Compile with timeout
    local compile_log="$test_dir/test-compile.log"
    if timeout $TEST_TIMEOUT latexmk -xelatex main.tex > "$compile_log" 2>&1; then
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        
        test_results["$test_name"]="PASS"
        test_times["$test_name"]=$duration
        test_logs["$test_name"]="Compiled successfully in ${duration}s"
        
        if [ "$VERBOSE" = false ]; then
            echo -e " ${GREEN}✓ PASSED${NC} (${duration}s)"
        else
            echo -e "  ${GREEN}✓ Test passed in ${duration}s${NC}"
        fi
        
        # Additional checks
        if [ "$test_type" = "full" ]; then
            run_additional_checks "$test_name" "$test_dir"
        fi
        
        return 0
    else
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        
        test_results["$test_name"]="FAIL"
        test_times["$test_name"]=$duration
        
        # Extract error message
        local error_msg=$(grep -E "(Error|Fatal|Emergency stop)" "$compile_log" | head -5 | tr '\n' ' ')
        test_logs["$test_name"]="Compilation failed: $error_msg"
        
        if [ "$VERBOSE" = false ]; then
            echo -e " ${RED}✗ FAILED${NC}"
        else
            echo -e "  ${RED}✗ Test failed${NC}"
            echo "  Error: $error_msg"
        fi
        
        return 1
    fi
}

# Function to run additional checks
run_additional_checks() {
    local test_name=$1
    local test_dir=$2
    
    if [ "$VERBOSE" = true ]; then
        echo "  Running additional checks..."
    fi
    
    # Check PDF exists
    if [ ! -f "$test_dir/main.pdf" ]; then
        echo -e "    ${YELLOW}⚠ PDF not generated${NC}"
        return 1
    fi
    
    # Check bibliography
    if [ -f "$test_dir/main.bbl" ]; then
        local bib_entries=$(grep -c "\\bibitem" "$test_dir/main.bbl" 2>/dev/null || echo 0)
        if [ "$VERBOSE" = true ]; then
            echo -e "    Bibliography entries: $bib_entries"
        fi
    fi
    
    # Check for warnings
    local warnings=$(grep -c "Warning" "$test_dir/test-compile.log" 2>/dev/null || echo 0)
    if [ $warnings -gt 0 ] && [ "$VERBOSE" = true ]; then
        echo -e "    ${YELLOW}⚠ $warnings warnings found${NC}"
    fi
    
    return 0
}

# Function to run tests in parallel
run_parallel_tests() {
    local pids=()
    
    echo "Running tests in parallel..."
    echo ""
    
    # Start all tests in background
    for test_config in "${test_configs[@]}"; do
        IFS='|' read -r test_name test_dir test_type <<< "$test_config"
        (run_test "$test_name" "$test_dir" "$test_type") &
        pids+=($!)
    done
    
    # Wait for all tests to complete
    for pid in "${pids[@]}"; do
        wait $pid
    done
}

# Function to run tests sequentially
run_sequential_tests() {
    for test_config in "${test_configs[@]}"; do
        IFS='|' read -r test_name test_dir test_type <<< "$test_config"
        run_test "$test_name" "$test_dir" "$test_type"
    done
}

# Define test configurations
test_configs=(
    "Basic Template|$BASE_DIR/test/test-basic|full"
    "Bachelor Template|$BASE_DIR/test/test-bachelor|full"
    "Master Template|$BASE_DIR/test/test-master|full"
    "Doctor Template|$BASE_DIR/test/test-doctor|full"
    "Bibliography Test|$BASE_DIR/test/test-bibliography|quick"
    "Math Mode Test|$BASE_DIR/test/test-math|quick"
    "Figure/Table Test|$BASE_DIR/test/test-figures|quick"
)

# Run tests
echo -e "${BLUE}Running ${#test_configs[@]} tests...${NC}"
echo ""

if [ "$PARALLEL" = true ]; then
    run_parallel_tests
else
    run_sequential_tests
fi

# Calculate statistics
total_tests=0
passed_tests=0
failed_tests=0
skipped_tests=0
total_time=0

for test_name in "${!test_results[@]}"; do
    ((total_tests++))
    case ${test_results[$test_name]} in
        PASS)
            ((passed_tests++))
            ;;
        FAIL)
            ((failed_tests++))
            ;;
        SKIP)
            ((skipped_tests++))
            ;;
    esac
    
    if [ -n "${test_times[$test_name]}" ]; then
        ((total_time += ${test_times[$test_name]}))
    fi
done

# Generate report
generate_text_report() {
    echo ""
    echo "════════════════════════════════════════"
    echo "            TEST SUMMARY"
    echo "════════════════════════════════════════"
    echo ""
    echo "Total:    $total_tests tests"
    echo -e "Passed:   ${GREEN}$passed_tests${NC}"
    echo -e "Failed:   ${RED}$failed_tests${NC}"
    echo -e "Skipped:  ${YELLOW}$skipped_tests${NC}"
    echo "Time:     ${total_time}s"
    echo ""
    
    if [ $failed_tests -gt 0 ]; then
        echo "Failed tests:"
        for test_name in "${!test_results[@]}"; do
            if [ "${test_results[$test_name]}" = "FAIL" ]; then
                echo -e "  ${RED}✗ $test_name${NC}"
                if [ "$VERBOSE" = true ]; then
                    echo "    ${test_logs[$test_name]}"
                fi
            fi
        done
        echo ""
    fi
    
    # Success rate
    if [ $total_tests -gt 0 ]; then
        local success_rate=$((passed_tests * 100 / total_tests))
        echo -n "Success rate: "
        if [ $success_rate -ge 90 ]; then
            echo -e "${GREEN}${success_rate}%${NC}"
        elif [ $success_rate -ge 70 ]; then
            echo -e "${YELLOW}${success_rate}%${NC}"
        else
            echo -e "${RED}${success_rate}%${NC}"
        fi
    fi
}

generate_markdown_report() {
    local report_file="${REPORT_FILE}.md"
    
    {
        echo "# CCNUthesis Test Report"
        echo ""
        echo "**Date:** $(date '+%Y-%m-%d %H:%M:%S')"
        echo "**Total Tests:** $total_tests"
        echo "**Duration:** ${total_time}s"
        echo ""
        echo "## Summary"
        echo ""
        echo "| Status | Count |"
        echo "|--------|-------|"
        echo "| ✅ Passed | $passed_tests |"
        echo "| ❌ Failed | $failed_tests |"
        echo "| ⏭️ Skipped | $skipped_tests |"
        echo ""
        echo "## Test Results"
        echo ""
        echo "| Test Name | Status | Duration | Notes |"
        echo "|-----------|--------|----------|-------|"
        
        for test_name in "${!test_results[@]}"; do
            local status="${test_results[$test_name]}"
            local duration="${test_times[$test_name]:-N/A}s"
            local notes="${test_logs[$test_name]}"
            
            case $status in
                PASS) status="✅ PASS" ;;
                FAIL) status="❌ FAIL" ;;
                SKIP) status="⏭️ SKIP" ;;
            esac
            
            echo "| $test_name | $status | $duration | ${notes:0:50}... |"
        done
        
    } > "$report_file"
    
    echo ""
    echo -e "${GREEN}Markdown report saved to: $report_file${NC}"
}

generate_html_report() {
    local report_file="${REPORT_FILE}.html"
    
    {
        echo "<!DOCTYPE html>"
        echo "<html><head>"
        echo "<title>CCNUthesis Test Report</title>"
        echo "<style>"
        echo "body { font-family: Arial, sans-serif; margin: 20px; }"
        echo "h1 { color: #333; }"
        echo ".summary { background: #f0f0f0; padding: 15px; border-radius: 5px; }"
        echo ".pass { color: green; font-weight: bold; }"
        echo ".fail { color: red; font-weight: bold; }"
        echo ".skip { color: orange; font-weight: bold; }"
        echo "table { border-collapse: collapse; width: 100%; margin-top: 20px; }"
        echo "th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }"
        echo "th { background-color: #4CAF50; color: white; }"
        echo "tr:nth-child(even) { background-color: #f2f2f2; }"
        echo "</style>"
        echo "</head><body>"
        echo "<h1>CCNUthesis Test Report</h1>"
        echo "<div class='summary'>"
        echo "<p><strong>Date:</strong> $(date '+%Y-%m-%d %H:%M:%S')</p>"
        echo "<p><strong>Total Tests:</strong> $total_tests</p>"
        echo "<p><strong>Duration:</strong> ${total_time}s</p>"
        echo "<p>"
        echo "<span class='pass'>Passed: $passed_tests</span> | "
        echo "<span class='fail'>Failed: $failed_tests</span> | "
        echo "<span class='skip'>Skipped: $skipped_tests</span>"
        echo "</p>"
        echo "</div>"
        echo "<h2>Test Results</h2>"
        echo "<table>"
        echo "<tr><th>Test Name</th><th>Status</th><th>Duration</th><th>Notes</th></tr>"
        
        for test_name in "${!test_results[@]}"; do
            local status="${test_results[$test_name]}"
            local duration="${test_times[$test_name]:-N/A}"
            local notes="${test_logs[$test_name]}"
            local class=""
            
            case $status in
                PASS) class="pass" ;;
                FAIL) class="fail" ;;
                SKIP) class="skip" ;;
            esac
            
            echo "<tr>"
            echo "<td>$test_name</td>"
            echo "<td class='$class'>$status</td>"
            echo "<td>${duration}s</td>"
            echo "<td>${notes}</td>"
            echo "</tr>"
        done
        
        echo "</table>"
        echo "</body></html>"
    } > "$report_file"
    
    echo ""
    echo -e "${GREEN}HTML report saved to: $report_file${NC}"
}

# Display summary
generate_text_report

# Generate report if requested
if [ "$GENERATE_REPORT" = true ]; then
    case $REPORT_FORMAT in
        markdown|md)
            generate_markdown_report
            ;;
        html)
            generate_html_report
            ;;
        *)
            # Text report already displayed
            ;;
    esac
fi

# Clean up if requested
if [ "$CLEAN_AFTER" = true ]; then
    echo ""
    echo "Cleaning auxiliary files..."
    for test_config in "${test_configs[@]}"; do
        IFS='|' read -r test_name test_dir test_type <<< "$test_config"
        if [ -d "$test_dir" ]; then
            cd "$test_dir"
            latexmk -c >/dev/null 2>&1
            rm -f test-compile.log
        fi
    done
fi

# Exit code
echo ""
if [ $failed_tests -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         All tests passed! 🎉          ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    exit 0
else
    echo -e "${RED}╔════════════════════════════════════════╗${NC}"
    echo -e "${RED}║      $failed_tests test(s) failed ⚠️               ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════╝${NC}"
    exit 1
fi