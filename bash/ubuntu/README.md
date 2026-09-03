# Ubuntu package management

This directory contains the minimal Ubuntu version of the daily package workflow used by the repo.

## What it does

The wrapper runs as the normal user `chadb` and performs the daily update flow:

- checks for stale or overlapping runs with a lock file
- writes start and finish markers to `bash/ubuntu/logs/package-manage.log`
- runs `git pull` from the repo root
- executes the Ubuntu `install-chad.sh` script
- uses `sudo -A` with `SUDO_ASKPASS` for root-only steps such as `apt-get` and `systemctl`

## Files

- `run-package-manage.sh` - runner and lock/log management
- `package-manage.service` - systemd service entry point
- `package-manage.timer` - runs the service at 04:00 daily
- `install-chad.sh` - wrapper or entry script for the actual Ubuntu install logic

## Unattended sudo setup

The systemd service runs as `chadb`, so the password for root operations must be supplied by a non-interactive askpass script outside the repo. This is required before the daily job can run without a terminal.

Create the password script for the user that runs the service:

```bash
mkdir -p ~/.ssh/secrets
cat > ~/.ssh/secrets/.supwd.sh <<'EOF'
#!/bin/bash
echo 'YOUR_UBUNTU_PASSWORD'
EOF
chmod 700 ~/.ssh/secrets/.supwd.sh
```

Verify it works in a terminal as the service user:

```bash
export SUDO_ASKPASS="$HOME/.ssh/secrets/.supwd.sh"
sudo -A -v
```

If that succeeds, the systemd unit can keep `Environment=SUDO_ASKPASS=/home/chadb/.ssh/secrets/.supwd.sh` and `Environment=USERNAME=chadb` and the service can run without interactively prompting for a password.

## First-time setup

The service runs as the normal user `chadb`, so the repo path must still be the actual checkout path and the askpass script must exist for that user before the timer is enabled.

```bash
sudo cp ./bash/ubuntu/package-manage.service /etc/systemd/system/package-manage.service
sudo cp ./bash/ubuntu/package-manage.timer /etc/systemd/system/package-manage.timer
sudo systemctl daemon-reload
sudo systemctl enable --now package-manage.timer
sudo systemctl status package-manage.timer
```

## Update existing setup after changes

```bash
sudo cp ./bash/ubuntu/package-manage.service /etc/systemd/system/package-manage.service
sudo cp ./bash/ubuntu/package-manage.timer /etc/systemd/system/package-manage.timer
sudo systemctl daemon-reload
sudo systemctl restart package-manage.timer
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
