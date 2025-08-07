#!/bin/bash
# Test script for CCNUthesis development

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}CCNUthesis Test Runner${NC}"
echo "========================"

# Function to run test
run_test() {
    local test_name=$1
    local test_dir=$2
    
    echo -e "\n${YELLOW}Testing: $test_name${NC}"
    echo "Directory: $test_dir"
    
    cd "$test_dir"
    
    # Clean previous builds
    latexmk -c 2>/dev/null
    
    # Compile
    if latexmk -xelatex main.tex > compile.log 2>&1; then
        echo -e "${GREEN}✓ $test_name passed${NC}"
        return 0
    else
        echo -e "${RED}✗ $test_name failed${NC}"
        echo "  Check $test_dir/compile.log for details"
        return 1
    fi
}

# Base directory
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$BASE_DIR"

# Run tests
failed_tests=0

# Test basic template
if ! run_test "Basic Template" "$BASE_DIR/test/test-basic"; then
    ((failed_tests++))
fi

# Test bachelor template
if [ -d "$BASE_DIR/test/test-bachelor" ] && [ -f "$BASE_DIR/test/test-bachelor/main.tex" ]; then
    if ! run_test "Bachelor Template" "$BASE_DIR/test/test-bachelor"; then
        ((failed_tests++))
    fi
fi

# Test master template  
if [ -d "$BASE_DIR/test/test-master" ] && [ -f "$BASE_DIR/test/test-master/main.tex" ]; then
    if ! run_test "Master Template" "$BASE_DIR/test/test-master"; then
        ((failed_tests++))
    fi
fi

# Test doctor template
if [ -d "$BASE_DIR/test/test-doctor" ] && [ -f "$BASE_DIR/test/test-doctor/main.tex" ]; then
    if ! run_test "Doctor Template" "$BASE_DIR/test/test-doctor"; then
        ((failed_tests++))
    fi
fi

# Summary
echo -e "\n========================"
if [ $failed_tests -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}$failed_tests test(s) failed${NC}"
    exit 1
fi