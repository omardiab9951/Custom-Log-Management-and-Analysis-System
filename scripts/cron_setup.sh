#!/usr/bin/env bash
# scripts/cron_setup.sh - Cyber Student (Week 3)
# Automatically configures a 10-minute cron job for the full pipeline

# Get absolute path to project folder
PROJECT_DIR=$(cd "$(dirname "$0")/.." && pwd)
CRON_LOG="$PROJECT_DIR/reports/cron_run.log"

# Create the cron entry (runs every 10 minutes)
# Format: minute hour day month weekday command
CRON_ENTRY="*/10 * * * * cd $PROJECT_DIR && bash scripts/collect_logs.sh && bash scripts/parser.sh && bash scripts/db_insert.sh >> $CRON_LOG 2>&1"

# Add to crontab (avoids duplicates)
if crontab -l 2>/dev/null | grep -q "collect_logs.sh"; then
    echo "✅ Cron job already exists. Skipping setup."
else
    (crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -
    echo "✅ Cron job configured successfully!"
    echo "📅 Pipeline will run every 10 minutes."
    echo "📜 Logs saved to: $CRON_LOG"
fi
