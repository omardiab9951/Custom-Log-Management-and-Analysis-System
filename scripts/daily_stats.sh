#!/usr/bin/env bash
# scripts/daily_stats.sh - DS Student B (Week 3 Parallel)
# Generates a text-based chart of logs per day

DB="logs_db.sqlite"

if [ ! -f "$DB" ]; then
    echo "❌ Database not found. Run db_insert.sh first."
    exit 1
fi

echo "====================================="
echo " 📊 DAILY LOG STATISTICS (Text Chart)"
echo "====================================="
echo ""

# Get max count for scaling
MAX=$(sqlite3 "$DB" "SELECT MAX(count) FROM (SELECT COUNT(*) as count FROM log_entries GROUP BY log_date);")
MAX=${MAX:-1}

# Print scaled bar chart with colors per status
sqlite3 "$DB" "SELECT log_date, status, COUNT(*) as count FROM log_entries GROUP BY log_date, status ORDER BY log_date;" | \
while IFS='|' read -r DATE STATUS COUNT; do
    BAR_LEN=$(( COUNT * 30 / MAX ))
    BAR=$(printf '#%.0s' $(seq 1 $BAR_LEN))
    if [ "$STATUS" = "Failed" ]; then
        printf "%-12s %-10s | \033[0;31m%-30s\033[0m (%d)\n" "$DATE" "$STATUS" "$BAR" "$COUNT"
    else
        printf "%-12s %-10s | \033[0;32m%-30s\033[0m (%d)\n" "$DATE" "$STATUS" "$BAR" "$COUNT"
    fi
done

echo ""
echo " Legend: $(printf '\033[0;31m#\033[0m') Failed   $(printf '\033[0;32m#\033[0m') Accepted"
echo "====================================="
echo "✅ Chart generation complete."
