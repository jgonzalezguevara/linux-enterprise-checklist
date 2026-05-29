#!/bin/bash

echo "================================="
echo "Linux Enterprise Health Check"
echo "================================="

echo
echo "[HOST]"
hostnamectl

echo
echo "[UPTIME]"
uptime

echo
echo "[MEMORY]"
free -h

echo
echo "[DISK]"
df -h

echo
echo "[NETWORK]"
ip addr

echo
echo "[FAILED SERVICES]"
systemctl --failed

echo
echo "[LOAD]"
cat /proc/loadavg

echo
echo "Health check completed."
