#!/usr/bin/env bash

INPUT_FILE="../data/auth.log"
OUTPUT_FILE="../data/parsed_logs.txt"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file not found!"
    exit 1
fi

> "$OUTPUT_FILE"

while read line; do
    [ -z "$line" ] && continue

    DATE=$(echo "$line" | awk '{print $1 $2}')
    TIME=$(echo "$line" | awk '{print $3}')

    if echo "$line" | grep -q "Failed"; then
        STATUS="Failed"
    elif echo "$line" | grep -q "Accepted"; then
        STATUS="Accepted"
    else
        continue
    fi

    USER=$(echo "$line" | awk -F'for ' '{print $2}' | awk '{print $1}')
    IP=$(echo "$line" | awk -F'from ' '{print $2}' | awk '{print $1}')

    if [ -z "$USER" ] || [ -z "$IP" ]; then
        continue
    fi

    echo "Date=$DATE Time=$TIME User=$USER Status=$STATUS IP=$IP" >> "$OUTPUT_FILE"

done < "$INPUT_FILE"

echo "Parsing completed. Output saved to $OUTPUT_FILE"
