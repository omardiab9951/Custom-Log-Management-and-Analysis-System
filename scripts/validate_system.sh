#!/usr/bin/env bash
#===============================================================================
# SCRIPT NAME: validate_system.sh
# DESCRIPTION: Validates system robustness and handles edge cases
# AUTHOR: Omar Diab
# VERSION: 1.0
#===============================================================================

set -euo pipefail
source "$(dirname "$0")/config.sh"

echo -e "${BLUE}🔍 Validating System Robustness...${NC}"
echo ""

ERRORS=0

# Check 1: Database exists
echo -n "Checking database... "
if [ ! -f "$DB_FILE" ]; then
    echo -e "${RED}❌ Database not found${NC}"
    ((ERRORS++))
else
    echo -e "${GREEN}✅ Database exists${NC}"
fi

# Check 2: Scripts are executable
echo -n "Checking script permissions... "
NON_EXECUTABLE=0
for script in "$PROJECT_DIR"/scripts/*.sh; do
    if [ ! -x "$script" ]; then
        ((NON_EXECUTABLE++))
    fi
done
if [ $NON_EXECUTABLE -gt 0 ]; then
    echo -e "${YELLOW}⚠️  $NON_EXECUTABLE scripts not executable${NC}"
else
    echo -e "${GREEN}✅ All scripts executable${NC}"
fi

# Check 3: Handle empty log file
echo -n "Testing edge case: Empty log... "
mkdir -p "$DATA_DIR/raw"
sudo bash -c "echo '' > '$RAW_LOG'"
if bash "$PROJECT_DIR/scripts/parser.sh" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Handles empty logs${NC}"
else
    echo -e "${RED}❌ Fails on empty logs${NC}"
    ((ERRORS++))
fi

# Check 4: Handle malformed log
echo -n "Testing edge case: Malformed log... "
echo "This is not a valid log line at all" > "$RAW_LOG"
if bash "$PROJECT_DIR/scripts/parser.sh" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Handles malformed logs${NC}"
else
    echo -e "${RED}❌ Fails on malformed logs${NC}"
    ((ERRORS++))
fi

# Check 5: Permission check
echo -n "Checking write permissions... "
if [ ! -w "$DATA_DIR/raw/" ]; then
    echo -e "${RED}❌ No write permission to data/raw/${NC}"
    ((ERRORS++))
else
    echo -e "${GREEN}✅ Write permissions OK${NC}"
fi

# Check 6: SQLite installed
echo -n "Checking SQLite... "
if command -v sqlite3 &> /dev/null; then
    echo -e "${GREEN}✅ SQLite installed${NC}"
else
    echo -e "${RED}❌ SQLite not installed${NC}"
    ((ERRORS++))
fi

echo ""
echo "====================================="
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All validations passed!${NC}"
else
    echo -e "${RED}❌ $ERRORS validation(s) failed${NC}"
fi
echo "====================================="

exit $ERRORS
