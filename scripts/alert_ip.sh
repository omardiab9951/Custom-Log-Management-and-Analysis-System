
#!/bin/bash
# =====================================
# alert_ip.sh - Cyber Student
# Prints WARNING if any single IP
# appears more than 3 times in
# the sorted log (possible attacker)
# =====================================

SORTED_FILE=~/Safe-Vision-Log-System/data/parsed_logs.txt
THRESHOLD=3

if [ ! -f "$SORTED_FILE" ]; then
    echo "[ERROR] sorted.log not found. Run parser.sh first."
    exit 1
fi

echo "==============================="
echo " IP Address Monitor"
echo " Threshold: >$THRESHOLD appearances"
echo "==============================="

# Extract all Source_IPs, count occurrences, sort by most frequent
IP_COUNTS=$(grep -o 'Source_IP=[^ ]*' "$SORTED_FILE" \
    | cut -d'=' -f2 \
    | sort \
    | uniq -c \
    | sort -rn)

if [ -z "$IP_COUNTS" ]; then
    echo " No IPs found in sorted log."
    exit 0
fi

echo ""
echo " Top IPs seen:"
echo "$IP_COUNTS" | while read COUNT IP; do
    echo "   $IP  ->  $COUNT time(s)"
done

echo ""
echo "--- Checking for threats ---"
echo ""

FOUND_THREAT=0

echo "$IP_COUNTS" | while read COUNT IP; do
    if [ "$COUNT" -gt "$THRESHOLD" ]; then
        FOUND_THREAT=1
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo "!!  WARNING: Suspicious IP     !!"
        echo "!!  IP      : $IP"
        echo "!!  Seen    : $COUNT times"
        echo "!!  Possible brute-force attack!!"
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo ""
    fi
done

# Check if any threat was found
OVER_THRESHOLD=$(echo "$IP_COUNTS" | awk -v t="$THRESHOLD" '$1 > t' | wc -l)
if [ "$OVER_THRESHOLD" -eq 0 ]; then
    echo "[OK] No suspicious IPs detected. All IPs within normal range."
fi



