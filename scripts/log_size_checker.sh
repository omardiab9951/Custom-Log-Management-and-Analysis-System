#!/usr/bin/env bash
# scripts/log_size_checker.sh - Cyber Student (Week 2)
# Monitors log file size changes

LOG_FILE="data/raw/auth.log"
SIZE_FILE="$(dirname "$0")/.last_size"

if [ ! -f "$LOG_FILE" ]; then
    echo "❌ Error: $LOG_FILE not found. Run collect_logs.sh first."
    exit 1
fi

# Get current file size in bytes
CURRENT_SIZE=$(stat -c%s "$LOG_FILE" 2>/dev/null || stat -f%z "$LOG_FILE" 2>/dev/null)

# Load previous size (if exists)
if [ -f "$SIZE_FILE" ]; then
    PREV_SIZE=$(cat "$SIZE_FILE")
else
    PREV_SIZE=0
fi

# Save current size for next run
echo "$CURRENT_SIZE" > "$SIZE_FILE"

echo "📏 Log Size Check:"
echo "Previous: ${PREV_SIZE} bytes"
echo "Current:  ${CURRENT_SIZE} bytes"
echo ""

if [ "$CURRENT_SIZE" -gt "$PREV_SIZE" ]; then
    echo "✅ System is generating new logs! (+$((CURRENT_SIZE - PREV_SIZE)) bytes)"
elif [ "$CURRENT_SIZE" -eq "$PREV_SIZE" ]; then
    echo "⚠️  Log file size unchanged. Check log rotation or collection script."
else
    echo "🔄 Log file was rotated or cleared. Size decreased."
fi
