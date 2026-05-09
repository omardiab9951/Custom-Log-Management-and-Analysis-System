#!/usr/bin/env bash
# scripts/generate_report.sh - DS Student A (Week 3)
DB="logs_db.sqlite"
REPORT_DIR="reports"
REPORT_FILE="$REPORT_DIR/daily_report.txt"

mkdir -p "$REPORT_DIR"

if [ ! -f "$DB" ]; then
    echo "❌ Database not found. Run db_insert.sh first."
    exit 1
fi

{
    echo "====================================="
    echo "   CUSTOM LOG ANALYSIS REPORT"
    echo "====================================="
    echo "📅 Generated: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""

    TOTAL=$(sqlite3 "$DB" "SELECT COUNT(*) FROM log_entries;")
    FAILED=$(sqlite3 "$DB" "SELECT COUNT(*) FROM log_entries WHERE status='Failed';")
    ACCEPTED=$(sqlite3 "$DB" "SELECT COUNT(*) FROM log_entries WHERE status='Accepted';")

    echo " SUMMARY"
    echo "Total Logs Processed: $TOTAL"
    echo "Failed Attempts:      $FAILED"
    echo "Accepted Logins:      $ACCEPTED"
    echo ""

    echo " TOP 3 TARGETED USERS:"
    sqlite3 -header -column "$DB" "
        SELECT username, COUNT(*) as attempts 
        FROM log_entries 
        WHERE status='Failed' 
        GROUP BY username 
        ORDER BY attempts DESC 
        LIMIT 3;
    "
    echo ""
    echo "====================================="
} | tee "$REPORT_FILE"

echo "✅ Report saved to: $REPORT_FILE"
