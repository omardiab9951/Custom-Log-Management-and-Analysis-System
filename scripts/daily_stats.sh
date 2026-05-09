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

# Query dates and counts, then format into a simple ASCII bar chart
sqlite3 "$DB" "SELECT log_date, COUNT(*) as count FROM log_entries GROUP BY log_date ORDER BY log_date;" | \
awk -F'|' '{
    bar = ""
    for(i=1; i<=$2; i++) bar = bar "#"
    printf "%-10s | %-20s (%d logs)\n", $1, bar, $2
}'

echo ""
echo "✅ Chart generation complete. (Adapted to pure Bash for Linux/Shell course)"
