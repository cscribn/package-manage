# Ubuntu package management

This directory contains the minimal Ubuntu version of the daily package workflow used by the repo.

## What it does

The wrapper runs as the normal user `chadb` and performs the daily update flow:

- checks for stale or overlapping runs with a lock file
- writes start and finish markers to `logs/package-manage.log`
- runs `git pull` from the repo root
- executes the Ubuntu `install-chad.sh` script
- uses `sudo -A` with `SUDO_ASKPASS` for root-only steps such as `apt-get` and `systemctl`

## Files

- `run-package-manage.sh` - runner and lock/log management
- `package-manage.service` - systemd service entry point
- `package-manage.timer` - runs the service at 04:00 daily
- `bin/install-chad.sh` - wrapper or entry script for the actual Ubuntu install logic

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

Every root operation in these scripts must use `sudo -A` (directly or through `apt_run`). The service has no terminal, so a bare `sudo` fails with `sudo: A terminal is required to authenticate` and aborts the workflow. `install-batocera-env.sh` also re-runs the workflow with `sudo -A su` after adding the user to the `docker` group, so the new group takes effect in the same run.

## Repository ownership and Git safety setup

The repo must be owned by the same user that runs the systemd service. If the checkout was created or changed by root, the service user will hit both `Permission denied` on the lock/log directory and `dubious ownership in repository` when Git runs.

Fix it once on the machine:

```bash
sudo chown -R chadb:chadb /home/chadb/package-manage
sudo install -d -o chadb -g chadb /home/chadb/package-manage/logs /home/chadb/package-manage/ubuntu/state
git config --global --add safe.directory /home/chadb/package-manage
```

You can also verify the service user can write and pull from the repo:

```bash
sudo -u chadb bash -lc 'touch /home/chadb/package-manage/ubuntu/state/test-write && git -C /home/chadb/package-manage pull'
```

## First-time setup

The service runs as the normal user `chadb`, so the repo path must still be the actual checkout path and the askpass script must exist for that user before the timer is enabled.

```bash
sudo cp ./ubuntu/package-manage.service /etc/systemd/system/package-manage.service
sudo cp ./ubuntu/package-manage.timer /etc/systemd/system/package-manage.timer
sudo systemctl daemon-reload
sudo systemctl enable --now package-manage.timer
sudo systemctl status package-manage.timer
```

## Update existing setup after changes

```bash
sudo cp ./ubuntu/package-manage.service /etc/systemd/system/package-manage.service
sudo cp ./ubuntu/package-manage.timer /etc/systemd/system/package-manage.timer
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
tail -f ./logs/package-manage.log
```

A successful run ends with `systemd finish` in the log.

## Troubleshooting

The runner redirects all step output to `logs/package-manage.log`, so a failure usually shows an exit code in `journalctl` with no detail there. Start with the log file:

```bash
tail -30 ~/package-manage/logs/package-manage.log
```

Common failures:

- `install-chad.sh finish (exit 126)` next to `Permission denied`: the script has no executable bit. Restore it with `chmod +x ubuntu/run-package-manage.sh ubuntu/bin/install-chad.sh ubuntu/lib/*.sh`. Current runners call the entry script through `bash`, but `install-batocera-env.sh` re-executes itself, so the bits still matter.
- `sudo authentication failed via SUDO_ASKPASS`: the askpass script is missing, not executable, or the password is wrong. Re-run the `sudo -A -v` check above as `chadb`.
- Nothing appended to the log at all: the service user cannot write `logs/` or `ubuntu/state/`. Run the `chown`/`install -d` commands above.
