
#!/bin/bash
# =====================================
# check_log_size.sh - Cyber Student
# Detects if auth.log has changed size
# since the last time it was checked
# =====================================

LOG_FILE="$(dirname "$0")/../data/raw/auth.log"
SIZE_RECORD="$(dirname "$0")/../data/last_size.txt"

# Make sure the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "[ERROR] Log file not found: $LOG_FILE"
    exit 1
fi

# Get current size in bytes
CURRENT_SIZE=$(stat -c%s "$LOG_FILE")

echo "==============================="
echo " Log Size Monitor"
echo "==============================="
echo " Current size: $CURRENT_SIZE bytes"

# First time running — save size and exit
if [ ! -f "$SIZE_RECORD" ]; then
    echo "$CURRENT_SIZE" > "$SIZE_RECORD"
    echo " No previous record found."
    echo " Size saved. Run again to detect changes."
    echo "==============================="
    exit 0
fi

# Read last recorded size
LAST_SIZE=$(cat "$SIZE_RECORD")
echo " Last recorded: $LAST_SIZE bytes"
echo "==============================="

# Compare sizes
if [ "$CURRENT_SIZE" -gt "$LAST_SIZE" ]; then
    DIFF=$((CURRENT_SIZE - LAST_SIZE))
    echo ""
    echo "[ALERT] Log file has GROWN by $DIFF bytes."
    echo "        New activity detected — run parser!"
elif [ "$CURRENT_SIZE" -lt "$LAST_SIZE" ]; then
    echo ""
    echo "[WARNING] Log file is SMALLER than before."
    echo "          Logs may have been cleared or rotated."
else
    echo ""
    echo "[OK] Log file size is unchanged. No new activity."
fi

# Update the saved size
echo "$CURRENT_SIZE" > "$SIZE_RECORD"
echo " Size record updated."

