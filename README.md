# Safe Vision Log System — Cyber Student Branch
### Student: Moaz Elsenosy | Role: Guard & Collector

---

## What Is This Project?

This project builds an **automated log monitoring system** on Linux. Every time something happens on a Linux machine (a login attempt, a failed password, a new connection), the system writes a record of it in a log file. This branch handles the **collection, monitoring, alerting, and automation** parts of the pipeline.

---

## Team Structure

| Student | Role | Responsibility |
|---|---|---|
| Cyber Student (Moaz) | Guard & Collector | Collect logs, monitor, alert, automate |
| DS Student A (Omar Nasr) | The Sorter | Parse raw logs into organized format |
| DS Student B (Omar Diab) | Warehouse Manager | Store parsed data into a database |

---

## Project File Structure

```
Safe-Vision-Log-System/
├── data/
│   ├── auth.log          # Raw log file (sample or real)
│   ├── parsed_logs.txt   # Omar's parser output
│   ├── last_size.txt     # Size tracker for check_log_size.sh
│   └── pipeline_run.log  # Full pipeline history log
├── scripts/
│   ├── collect_logs.sh   # [Cyber] Verifies log file exists
│   ├── parser.sh         # [DS-A]  Parses raw logs
│   ├── alarm.sh          # [Cyber] Alarms on too many failures
│   ├── alert_ip.sh       # [Cyber] Flags suspicious IPs
│   ├── check_log_size.sh # [Cyber] Monitors log file growth
│   └── main.sh           # [Cyber] Runs full pipeline
└── README.md
```

---

## Scripts — What Each One Does

### `collect_logs.sh`
Verifies the log file exists before the pipeline starts. If the file is missing, it stops everything and prints an error. If it exists, it reports the file size and line count.

```bash
bash collect_logs.sh
```

---

### `check_log_size.sh`
Monitors whether the log file is growing over time. Saves the file size on each run and compares it to the previous run:
- File grew → new activity detected
- File shrank → possible tampering or log rotation
- No change → all quiet

```bash
bash check_log_size.sh
```

---

### `alarm.sh`
Scans `parsed_logs.txt` and counts all failed login attempts. If the count exceeds 3, it triggers a loud ALARM — indicating a possible brute-force attack.

```bash
bash alarm.sh
```

**Example output:**
```
===============================
 Scanning parsed_logs.txt...
 Found: 6 Failed attempts
===============================
!!!!!!!!!!!!!!!!!!!!!!!!!!
!!       ALARM!!!!      !!
!! 6 Failed logins !!
!! Possible Attack!     !!
!!!!!!!!!!!!!!!!!!!!!!!!!!
```

---

### `alert_ip.sh`
Goes further than `alarm.sh` — instead of just counting failures, it identifies **which IP address** is attacking. If any single IP appears more than 3 times, it prints a WARNING with the IP and count.

```bash
bash alert_ip.sh
```

**Example output:**
```
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!  WARNING: Suspicious IP     !!
!!  IP      : 192.168.1.5
!!  Seen    : 5 times
!!  Possible brute-force attack!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
```

---

### `main.sh`
The master pipeline script. Runs all scripts in the correct order and logs every step to `data/pipeline_run.log`.

```bash
bash main.sh
```

**Pipeline order:**
```
1. collect_logs.sh   → verify log file exists
2. parser.sh         → parse raw logs (Omar Nasr's script)
3. alarm.sh          → check for too many failures
4. alert_ip.sh       → check for suspicious IPs
```

---

## Automation — Cron Job

The pipeline runs automatically every 10 minutes using a cron job.

**Setup (run once):**
```bash
crontab -e
```

**Add this line:**
```
*/10 * * * * bash /root/Safe-Vision-Log-System/scripts/main.sh
```

**Verify it's active:**
```bash
crontab -l
```

---

## How to Run the Full Demo

```bash
# 1. Go to scripts folder
cd ~/Safe-Vision-Log-System/scripts

# 2. Make all scripts executable
chmod +x *.sh

# 3. Run Omar's parser first
bash parser.sh

# 4. Run the full pipeline
bash main.sh
```

---

## Live Security Test

To demonstrate the system catching a real attack:

```bash
# Start SSH service
service ssh start

# Simulate failed logins (type wrong password 3-4 times)
ssh wronguser@localhost

# Capture real system logs
journalctl _COMM=sshd-session > ../data/auth.log

# Run parser and alarm
bash parser.sh
bash alarm.sh
```

**Note:** On Kali Linux, SSH logs are stored under `sshd-session` instead of the standard `sshd`.

**Result:** The system detected 6 real failed login attempts and triggered the ALARM in real time. ✅

---

## Problems Encountered & Fixes

| Problem | Cause | Fix |
|---|---|---|
| `collect_logs.sh` couldn't find log file | Path pointed to `/var/log/auth.log` | Changed path to `data/auth.log` |
| `alarm.sh` found 0 failures | Reading from wrong file path | Changed to read from `parsed_logs.txt` |
| `alert_ip.sh` found 0 IPs | Same path mismatch | Changed to read from `parsed_logs.txt` |
| SSH connection refused | SSH service not running | Run `service ssh start` first |
| `journalctl _COMM=sshd` returned nothing | Kali uses `sshd-session` not `sshd` | Used `journalctl _COMM=sshd-session` |

---

## Task Completion Summary

| Week | Task | Status |
|---|---|---|
| 1 | `collect_logs.sh` | ✅ Done |
| 1 | Folder structure & permissions | ✅ Done |
| 2 | `check_log_size.sh` | ✅ Done |
| 2 | `alert_ip.sh` emergency alert | ✅ Done |
| 3 | `main.sh` pipeline runner | ✅ Done |
| 3 | Cron job every 10 minutes | ✅ Done |
| 3 | Live security test | ✅ Done |

---

*All Cyber Student tasks completed successfully.* 🎉
