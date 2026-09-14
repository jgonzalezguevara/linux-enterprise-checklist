# Linux Enterprise Checklist

Structured checklist for reviewing the operational state of Linux systems.

## 1. System identity

Check:

    hostnamectl
    uptime
    timedatectl

Review:

- Host identity
- Operating system
- Kernel
- Uptime
- Timezone
- Time synchronization

## 2. CPU

Check:

    lscpu
    top
    mpstat -P ALL 1 5

Review:

- CPU architecture
- CPU count
- Load average
- Sustained CPU usage
- Unexpected processes

`mpstat` is normally provided by the `sysstat` package.

## 3. Memory

Check:

    free -h
    vmstat 1 5

Review:

- Available memory
- Swap activity
- Sustained memory pressure
- Process allocation

## 4. Storage

Check:

    df -h
    lsblk
    iostat -x 1 5

Review:

- Filesystem utilization
- Mount points
- Block devices
- I/O latency
- Disk saturation

`iostat` is normally provided by the `sysstat` package.

## 5. Network

Check:

    ip -brief addr
    ip route
    ss -tulpn

Review:

- Interface state
- Assigned addresses
- Routing
- Listening services
- Unexpected exposed ports

## 6. Services

Check:

    systemctl --failed
    systemctl list-units --type=service --state=running

Review:

- Failed units
- Unexpected stopped services
- Unexpected running services
- Service dependencies

## 7. Logs

Check:

    journalctl -p err -b
    journalctl -xe

Review recent errors and correlate them with service, kernel and application events.

## 8. Accounts and access

Depending on the operating system and policy, review:

    last
    lastlog
    getent passwd

Also validate:

- Privileged accounts
- Administrative access
- SSH policy
- Sudo configuration
- Obsolete accounts

## 9. Security

Review:

- Security updates
- SSH configuration
- Host firewall
- Audit configuration
- Failed authentication attempts
- Unexpected listening services
- File permissions on sensitive configuration

Security requirements must be adapted to the target environment.

## 10. Monitoring

Verify that the expected monitoring agent or exporter is installed, enabled and reporting successfully.

Examples may include:

    systemctl status zabbix-agent
    systemctl status zabbix-agent2
    systemctl status node_exporter

Do not assume every system uses the same monitoring stack.

## 11. Backups

Validate:

- Backup jobs are executing
- Backup failures are monitored
- Retention matches policy
- Restore procedures are documented
- Restore tests are performed
- Backup storage is reachable and protected

A successful backup job is not sufficient evidence of recoverability without restore validation.

## 12. Final review

Record:

- Findings
- Risks
- Required actions
- Responsible owner
- Priority
- Validation date

The checklist should complement monitoring, configuration management and organization-specific operational procedures.
