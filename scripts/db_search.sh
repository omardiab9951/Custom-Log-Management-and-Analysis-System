#!/usr/bin/env bash
# scripts/db_search.sh - DS Student B (Week 2 Parallel)
# Proves the database can filter and display only "Failed" attempts

DB="logs_db.sqlite"

if [ ! -f "$DB" ]; then
    echo "❌ Error: Database not found. Run db_insert.sh first."
    exit 1
fi

echo "================================="
echo " 🔍 SEARCHING: Failed Login Attempts"
echo "================================="
echo ""

# Query only Failed status, format as clean table
sqlite3 -header -column "$DB" "
    SELECT log_date, log_time, username, source_ip 
    FROM log_entries 
    WHERE status='Failed'
    ORDER BY log_date DESC, log_time DESC;
"

echo ""
COUNT=$(sqlite3 "$DB" "SELECT COUNT(*) FROM log_entries WHERE status='Failed';")
echo "✅ Found $COUNT failed attempt(s) in the database."
