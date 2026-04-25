#!/bin/bash
# ================================
# alarm.sh - Student 3
# Reads sorted.log, screams ALARM
# if "Failed" appears more than 3x
# ================================

SORTED_FILE=~/Safe-Vision-Log-System/data/sorted/sorted.log

# Count how many lines contain the word "Failed"
COUNT=$(grep -i "Failed" "$SORTED_FILE" | wc -l)

echo "==============================="
echo " Scanning sorted.log..."
echo " Found: $COUNT Failed attempts"
echo "==============================="

if [ "$COUNT" -gt 3 ]; then
    echo ""
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "!!       ALARM!!!!      !!"
    echo "!! $COUNT Failed logins !!"
    echo "!! Possible Attack!     !!"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!"
else
    echo ""
    echo "All clear. Only $COUNT failed attempt(s)."
fi
