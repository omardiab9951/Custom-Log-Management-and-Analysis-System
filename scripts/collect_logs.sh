#!/usr/bin/env bash
# scripts/collect_logs.sh - Cyber Student (Week 1)
# Copies fresh auth logs to data/raw/auth.log

source "$(dirname "$0")/config.sh"
OUTPUT="$RAW_LOG"


# Auto-detect auth log: try flat files first, then journald (Kali default)
SOURCE_LOG=""
for _candidate in "/var/log/secure" "/var/log/auth.log" \
                  "/var/log/audit/audit.log" "/var/log/syslog" \
                  "/var/log/messages"; do
    if [ -f "$_candidate" ] && [ -r "$_candidate" ]; then
        SOURCE_LOG="$_candidate"
        break
    fi
done

if [ -n "$SOURCE_LOG" ]; then
    echo "📥 Collecting logs from $SOURCE_LOG..."
    tail -n 100 "$SOURCE_LOG" > "$OUTPUT"
elif command -v journalctl &>/dev/null; then
    echo "📥 No flat auth log found. Collecting from systemd journal (Kali default)..."
    journalctl -n 100 --no-pager --output=short-traditional \
        -u ssh -u sshd \
        --merge 2>/dev/null > "$OUTPUT"
    # If SSH unit had no entries, fall back to full journal tail
    if [ ! -s "$OUTPUT" ]; then
        journalctl -n 100 --no-pager --output=short-traditional 2>/dev/null > "$OUTPUT"
    fi
    SOURCE_LOG="journald"
else
    echo "❌ Error: No auth log source found."
    echo "   Checked: /var/log/secure, /var/log/auth.log, /var/log/syslog, journald"
    echo "   Fix:     apt-get install -y rsyslog && systemctl enable --now rsyslog"
    exit 1
fi



# Check if collected logs have any useful SSH entries
USEFUL=$(grep -cE "Failed|Accepted" "$OUTPUT" 2>/dev/null)
USEFUL=${USEFUL:-0}

if [ "$USEFUL" -eq 0 ]; then
    echo "⚠️  No SSH login events found in real log. Generating test data..."
    cat > "$OUTPUT" << 'EOF'
May 13 16:00:01 localhost sshd[1001]: Failed password for root from 192.168.1.100 port 22 ssh2
May 13 16:00:05 localhost sshd[1002]: Failed password for admin from 192.168.1.100 port 22 ssh2
May 13 16:00:10 localhost sshd[1003]: Failed password for omar from 10.0.0.5 port 22 ssh2
May 13 16:00:15 localhost sshd[1004]: Failed password for test from 10.0.0.5 port 22 ssh2
May 13 16:01:00 localhost sshd[1005]: Accepted password for omar from 192.168.1.1 port 22 ssh2
May 13 16:01:30 localhost sshd[1006]: Accepted publickey for omar from 192.168.1.1 port 22 ssh2
EOF
    echo "✅ Test data generated → $OUTPUT"
else
    echo "✅ Collected $USEFUL SSH log lines → $OUTPUT"
fi
