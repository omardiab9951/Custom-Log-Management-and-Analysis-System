#!/bin/bash
# =====================================
# collect_logs.sh - Cyber Student
# Verifies the sample log file exists
# and copies it to the working location
# =====================================

SOURCE="$(dirname "$0")/../data/auth.log"
DEST="$(dirname "$0")/../data/auth.log"

# Create directory if not exists
mkdir -p "$(dirname "$0")/../data/raw"

# Check if source log exists
if [ ! -f "$SOURCE" ]; then
    echo "[ERROR] auth.log not found at: $SOURCE"
    echo "        Make sure the sample log file is placed in data/raw/"
    exit 1
fi

# Get file size and line count for info
SIZE=$(du -sh "$SOURCE" | cut -f1)
LINES=$(wc -l < "$SOURCE")

echo "==============================="
echo " Log Collection Report"
echo "==============================="
echo " File : $SOURCE"
echo " Size : $SIZE"
echo " Lines: $LINES"
echo " Status: Ready for parsing"
echo "==============================="


