# Linux Enterprise Checklist

Operational Linux review checklist with a lightweight health-check script for infrastructure validation and troubleshooting.

The project provides a repeatable starting point for reviewing Linux systems without replacing monitoring platforms, configuration management or organization-specific operating procedures.

## Use cases

- Server health reviews
- New-system validation
- Operational audits
- Troubleshooting
- Pre-change reviews
- Periodic infrastructure checks
- Baseline verification

## Review areas

The checklist covers:

- System identity and uptime
- CPU and load
- Memory
- Storage
- Network
- Services
- Logs
- Accounts and access
- Security
- Monitoring
- Backups

## Repository structure

    docs/
      checklist.md

    scripts/
      linux-health-check.sh

## Health-check script

Run:

    ./scripts/linux-health-check.sh

The script performs read-only operating-system checks and reports:

- Host information
- CPU information
- Memory utilization
- Filesystem usage
- Network configuration
- Failed systemd services
- Recent system errors

The default filesystem warning threshold is 90%.

It can be changed with:

    DISK_WARN_PERCENT=85 ./scripts/linux-health-check.sh

The script returns:

    0  no operational warnings detected
    1  one or more warnings detected

Unavailable optional commands are reported as skipped instead of terminating the complete review.

## Manual checklist

The detailed operational checklist is available at:

    docs/checklist.md

Some commands such as `mpstat` and `iostat` require the `sysstat` package.

## Scope

This repository is an operational review aid.

It does not replace:

- Monitoring
- Security assessment
- Configuration management
- Backup verification
- Incident procedures
- Organization-specific compliance controls

Results must be interpreted according to the role and expected configuration of each system.

## Technologies

Applicable to common Linux server environments including:

- SUSE Linux Enterprise
- Red Hat Enterprise Linux
- Ubuntu Server
- Other systemd-based Linux distributions

The checklist can also support hosts running virtualization, containers or Kubernetes workloads, but it remains focused on operating-system review.

## Related resources

Technical documentation:

    https://desdeelservidor.es

GitHub:

    https://github.com/jgonzalezguevara

## Author

Jose González
