
#!/bin/bash
# ================================
# alarm.sh - Student 3
# Reads parsed_logs.txt, screams ALARM
# if "Failed" appears more than 3x
# ================================

SORTED_FILE=~/Safe-Vision-Log-System/data/parsed_logs.txt

# Count how many lines contain the word "Failed"
COUNT=$(grep -i "Failed" "$SORTED_FILE" | wc -l)

echo "==============================="
echo " Scanning parsed_logs.txt..."
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

