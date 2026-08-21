# package-manage

## Configure

Configure project after cloning.

```zsh
git config core.hooksPath .githooks
```

## pi* & ubuntu*

Bash scripts that install/upgrade Raspberry Pi/Ubuntu packages.

## mac*

Bash scripts that install/upgrade Mac packages.

### mac prerequisites

Install brew via Terminal

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### mac launchd (setup/update)

Use launchd to run the daily mac package workflow.

First-time setup

```zsh
cp ./bash/macos/launchd/package-manage.plist ~/Library/LaunchAgents/
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/package-manage.plist
```

Update existing setup after script path changes

```zsh
launchctl bootout gui/$(id -u)/com.appfire-chadscribner.package-manage
cp ./bash/macos/launchd/package-manage.plist ~/Library/LaunchAgents/
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/package-manage.plist
launchctl kickstart -k gui/$(id -u)/com.appfire-chadscribner.package-manage
```

Verify and monitor logs

```zsh
launchctl print gui/$(id -u)/com.appfire-chadscribner.package-manage
tail -f ./bash/macos/logs/package-manage.log
tail -f ./bash/macos/logs/package-manage-launchd.log
```

See [mac launchd troubleshooting](#mac-launchd-troubleshooting) if a scheduled run did not happen.

### mac launchd troubleshooting

Diagnose:

```zsh
launchctl print gui/$(id -u)/com.appfire-chadscribner.package-manage | rg "state|runs|last exit|pid"
ls -la ./bash/macos/logs/package-manage*.log
tail ./bash/macos/logs/package-manage.log
pgrep -lf "install-chad|package-manage|brew upgrade"
cat ./bash/macos/logs/package-manage-launchd.log   # empty = healthy
```

- `state = running` with an old log → stuck prior run blocked the schedule.
- No ~4 AM entry today, or log ends mid-`brew upgrade`/download → missed or hung run.
- Also check: Mac asleep at 4 AM, `Password is incorrect.` in the log, or repo moved (re-bootstrap).

Recover:

| Symptom | Action |
| --- | --- |
| Stuck or missed run | `launchctl kickstart -k gui/$(id -u)/com.appfire-chadscribner.package-manage` |
| Kickstart does not clear children | Kill PID from `launchctl print`, then kickstart again |
| Hung Homebrew download | Remove `*.incomplete` in `~/Library/Caches/Homebrew/downloads/`, retry |
| Job not loaded or plist changed | Re-run setup/update steps above |

A healthy run writes `launchd start` and `launchd finish (exit N)` to `package-manage.log`.

## pwsh/

Powershell scripts that install/upgrade Windows packages. Different files are used for different machines.

### Win prerequisites

Install Chocolatey via PowerShell

```pwsh
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Download and install the lates PowerShell Core release from [GitHub](https://github.com/PowerShell/PowerShell/releases).

Set the Execution Policy in PowerShell Core

```pwsh
Set-ExecutionPolicy Unrestricted
```

Unblock all script files in the package-manage directory

```pwsh
dir -r | Unblock-File
```

Run all scripts using PowerShell Core
