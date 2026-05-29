# Linux Enterprise Checklist

## System

hostnamectl
uptime
timedatectl

## CPU

lscpu
top
mpstat -P ALL 1 5

## Memory

free -h
vmstat 1 5

## Storage

df -h
lsblk
iostat -x 1 5

## Network

ip addr
ip route
ss -tulpn

## Services

systemctl --failed
systemctl list-units --type=service --state=running

## Logs

journalctl -p err -b
journalctl -xe

## Security

last
lastlog
sudo -l

## Monitoring

systemctl status zabbix-agent
systemctl status node_exporter

## Backups

Check backup jobs
Check restore procedures
Check retention policies

