#!/usr/bin/env bash

source "$(dirname "$0")/config.sh"

# Access Control - restrict to authorized users
AUTHORIZED_USERS=("omar" "muaaz" "root")
CURRENT_USER=$(whoami)

IS_AUTHORIZED=0
for USER in "${AUTHORIZED_USERS[@]}"; do
    if [ "$CURRENT_USER" = "$USER" ]; then
        IS_AUTHORIZED=1
        break
    fi
done

if [ "$IS_AUTHORIZED" -eq 0 ]; then
    echo -e "${RED}❌ Access Denied: $CURRENT_USER is not authorized to run this system.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Access granted: Welcome, $CURRENT_USER${NC}"
sleep 1

while true; do
    clear
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}   CUSTOM LOG ANALYSIS SYSTEM${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    echo -e "${GREEN}--- Data Collection & Processing ---${NC}"
    echo -e "1. Collect Logs"
    echo -e "2. Parse Logs"
    echo -e "3. Insert to Database"
    echo -e "4. Generate Report"
    echo -e "5. Run Full Pipeline"
    echo ""
    echo -e "${YELLOW}--- Analysis & Queries ---${NC}"
    echo -e "6. Search Failed Logins"
    echo -e "7. Performance Analysis"
    echo -e "8. Daily Statistics"
    echo ""
    echo -e "${RED}--- System & Security ---${NC}"
    echo -e "9. Check Alerts"
    echo -e "10. Setup Cron Job"
    echo -e "11. Validate System"
    echo -e "12. Run Tests"
    echo ""
    echo -e "0. Exit"
    echo ""
    echo -n "Enter choice [0-12]: "
    read choice

    case $choice in
        1)
            echo -e "${BLUE}Collecting logs...${NC}"
            sudo bash "$PROJECT_DIR/scripts/collect_logs.sh"
            ;;
        2)
            echo -e "${BLUE}Parsing logs...${NC}"
            bash "$PROJECT_DIR/scripts/parser.sh"
            ;;
        3)
            echo -e "${BLUE}Inserting to database...${NC}"
            bash "$PROJECT_DIR/scripts/db_insert.sh"
            ;;
        4)
            echo -e "${BLUE}Generating report...${NC}"
            bash "$PROJECT_DIR/scripts/generate_report.sh"
            ;;
        5)
            echo -e "${BLUE}Running full pipeline...${NC}"
            sudo bash "$PROJECT_DIR/scripts/collect_logs.sh" && \
            bash "$PROJECT_DIR/scripts/parser.sh" && \
            bash "$PROJECT_DIR/scripts/db_insert.sh" && \
            bash "$PROJECT_DIR/scripts/generate_report.sh"
            ;;
        6)
            echo -e "${BLUE}Searching failed logins...${NC}"
            bash "$PROJECT_DIR/scripts/db_search.sh"
            ;;
        7)
            echo -e "${BLUE}Analyzing performance...${NC}"
            bash "$PROJECT_DIR/scripts/performance_analyzer.sh"
            ;;
        8)
            echo -e "${BLUE}Generating daily statistics...${NC}"
            bash "$PROJECT_DIR/scripts/daily_stats.sh"
            ;;
        9)
            echo -e "${BLUE}Checking alerts...${NC}"
            bash "$PROJECT_DIR/scripts/alarm.sh"
            ;;
        10)
            echo -e "${BLUE}Setting up cron job...${NC}"
            bash "$PROJECT_DIR/scripts/cron_setup.sh"
            ;;
        11)
            echo -e "${BLUE}Validating system...${NC}"
            bash "$PROJECT_DIR/scripts/validate_system.sh"
            ;;
        12)
            echo -e "${BLUE}Running tests...${NC}"
            bash "$PROJECT_DIR/scripts/run_tests.sh"
            ;;
        0)
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            sleep 2
            ;;
    esac

    echo ""
    echo -n "Press Enter to continue..."
    read
done
