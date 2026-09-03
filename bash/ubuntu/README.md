# Ubuntu package management

This directory contains the minimal Ubuntu version of the daily package workflow used by the repo.

## What it does

The wrapper runs as root and performs the daily update flow:

- checks for stale or overlapping runs with a lock file
- writes start and finish markers to `bash/ubuntu/logs/package-manage.log`
- runs `git pull` from the repo root
- executes the Ubuntu `install-chad.sh` script

## Files

- `run-package-manage.sh` - runner and lock/log management
- `package-manage.service` - systemd service entry point
- `package-manage.timer` - runs the service at 04:00 daily
- `install-chad.sh` - wrapper or entry script for the actual Ubuntu install logic

## Setup

The service runs as root via systemd, so the wrapper and Ubuntu install scripts do not use `sudo` internally. Update the repo path in the service before installing it:

```bash
sudo sed -i 's#/path/to/package-manage#'"$(pwd)"'#g' ./bash/ubuntu/package-manage.service
sudo cp ./bash/ubuntu/package-manage.service /etc/systemd/system/package-manage.service
sudo cp ./bash/ubuntu/package-manage.timer /etc/systemd/system/package-manage.timer
sudo systemctl daemon-reload
sudo systemctl enable --now package-manage.timer
sudo systemctl status package-manage.timer
```

## Manual run

```bash
sudo systemctl start package-manage.service
sudo journalctl -u package-manage.service -f
```

## Log inspection

```bash
tail -f ./bash/ubuntu/logs/package-manage.log
```

A successful run ends with `systemd finish` in the log.
