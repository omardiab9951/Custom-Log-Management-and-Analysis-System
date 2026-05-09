#!/usr/bin/env bash
# scripts/performance_analyzer.sh - DS Student B (Week 3 Sequential)
# Identifies the busiest hour of the day from the database

DB="logs_db.sqlite"

if [ ! -f "$DB" ]; then
    echo "❌ Database not found. Run db_insert.sh first."
    exit 1
fi

echo "====================================="
echo " 📈 PERFORMANCE ANALYZER (Busiest Hour)"
echo "====================================="
echo ""

# Extract hour, count logs, sort descending, get top 1
RESULT=$(sqlite3 "$DB" "SELECT substr(log_time, 1, 2) || ':00', COUNT(*) FROM log_entries GROUP BY 1 ORDER BY 2 DESC LIMIT 1;")

BUSIEST_HOUR=$(echo "$RESULT" | cut -d'|' -f1)
LOG_COUNT=$(echo "$RESULT" | cut -d'|' -f2)

if [ -z "$BUSIEST_HOUR" ]; then
    echo "⚠️  No logs found in the database to analyze."
else
    echo "🏆 Busiest Hour: $BUSIEST_HOUR"
    echo " Total Logs in that Hour: $LOG_COUNT"
    echo ""
    echo "💡 Recommendation: Increase monitoring/alert thresholds during this window."
fi
echo "====================================="
