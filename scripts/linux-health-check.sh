#!/usr/bin/env bash

set -u

DISK_WARN_PERCENT="${DISK_WARN_PERCENT:-90}"
WARNINGS=0
SKIPPED=0

section() {
    printf '\n=================================\n'
    printf '%s\n' "$1"
    printf '=================================\n'
}

run_cmd() {
    local command_name="$1"
    shift

    if command -v "$command_name" >/dev/null 2>&1; then
        "$@" || true
    else
        echo "[SKIP] Command not available: $command_name"
        SKIPPED=$((SKIPPED + 1))
    fi
}

section "Linux Enterprise Health Check"

echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "Host: $(hostname 2>/dev/null || echo unknown)"

section "SYSTEM"

run_cmd hostnamectl hostnamectl
run_cmd uptime uptime
run_cmd timedatectl timedatectl

section "CPU"

run_cmd lscpu lscpu

if [[ -r /proc/loadavg ]]; then
    echo
    echo "Load average:"
    cat /proc/loadavg
fi

section "MEMORY"

run_cmd free free -h

section "STORAGE"

run_cmd lsblk lsblk

if command -v df >/dev/null 2>&1; then
    df -h

    echo
    echo "Filesystem usage validation:"

    while read -r filesystem percent mountpoint; do
        usage="${percent%%%}"

        if [[ "$usage" =~ ^[0-9]+$ ]] &&
           (( usage >= DISK_WARN_PERCENT )); then
            echo "[WARN] $filesystem mounted on $mountpoint is ${usage}% full"
            WARNINGS=$((WARNINGS + 1))
        fi
    done < <(
        df -P -x tmpfs -x devtmpfs 2>/dev/null |
        awk 'NR > 1 {print $1, $5, $6}'
    )
else
    echo "[SKIP] Command not available: df"
    SKIPPED=$((SKIPPED + 1))
fi

section "NETWORK"

run_cmd ip ip -brief addr
echo
run_cmd ip ip route
echo
run_cmd ss ss -tulpn

section "SERVICES"

if command -v systemctl >/dev/null 2>&1; then
    FAILED_UNITS="$(
        systemctl --failed --no-legend --plain 2>/dev/null || true
    )"

    if [[ -n "$FAILED_UNITS" ]]; then
        echo "$FAILED_UNITS"
        FAILED_COUNT="$(printf '%s\n' "$FAILED_UNITS" | grep -c . || true)"
        WARNINGS=$((WARNINGS + FAILED_COUNT))
        echo
        echo "[WARN] Failed systemd units: $FAILED_COUNT"
    else
        echo "[PASS] No failed systemd units detected"
    fi
else
    echo "[SKIP] systemctl not available"
    SKIPPED=$((SKIPPED + 1))
fi

section "RECENT SYSTEM ERRORS"

if command -v journalctl >/dev/null 2>&1; then
    journalctl -p err -b --no-pager -n 25 2>/dev/null || true
else
    echo "[SKIP] journalctl not available"
    SKIPPED=$((SKIPPED + 1))
fi

section "SUMMARY"

echo "Warnings: $WARNINGS"
echo "Skipped checks: $SKIPPED"
echo "Disk warning threshold: ${DISK_WARN_PERCENT}%"

if (( WARNINGS > 0 )); then
    echo "RESULT: ATTENTION REQUIRED"
    exit 1
fi

echo "RESULT: OK"
exit 0
