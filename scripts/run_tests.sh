#!/usr/bin/env bash
#===============================================================================
# SCRIPT NAME: run_tests.sh
# DESCRIPTION: Automated testing suite for the log analysis system
# AUTHOR: Omar Diab
# VERSION: 1.0
#===============================================================================

set -uo pipefail
source "$(dirname "$0")/config.sh"

echo -e "${BLUE}🧪 Running Automated Tests...${NC}"
echo ""

TESTS_PASSED=0
TESTS_FAILED=0

run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -n "Testing: $test_name... "
    if eval "$test_command" > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}FAIL${NC}"
        ((TESTS_FAILED++))
    fi
}

# Test 1: Database schema
run_test "Database schema" "sqlite3 $DB_FILE '.tables' | grep -q log_entries"

# Test 2: Parser output
run_test "Parser generates CSV" "[[ -f $SORTED_LOG ]]"

# Test 3: Report generation
run_test "Report file created" "[[ -f $REPORTS_DIR/daily_report.txt ]]"

# Test 4: Cron job exists
run_test "Cron job configured" "crontab -l 2>/dev/null | grep -q collect_logs.sh"

# Test 5: All scripts exist
run_test "All scripts present" "[[ \$(ls $PROJECT_DIR/scripts/*.sh 2>/dev/null | wc -l) -ge 10 ]]"

# Test 6: Config file exists
run_test "Config file exists" "[[ -f $PROJECT_DIR/scripts/config.sh ]]"

# Test 7: .gitignore exists
run_test "Gitignore exists" "[[ -f $PROJECT_DIR/.gitignore ]]"

# Test 8: Directory structure
run_test "Directory structure" "[[ -d $DATA_DIR/raw && -d $DATA_DIR/sorted && -d $REPORTS_DIR ]]"

echo ""
echo "====================================="
echo -e "Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests Failed: ${RED}$TESTS_FAILED${NC}"
echo "====================================="

if [ $TESTS_FAILED -gt 0 ]; then
    exit 1
fi
exit 0
