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

### mac askpass (unattended sudo)

Some brew cask installs/upgrades require sudo. For launchd runs (no terminal), create an askpass script outside this repo:

```zsh
mkdir -p ~/.ssh/secrets
cat > ~/.ssh/secrets/.supwd.sh <<'EOF'
#!/opt/homebrew/bin/bash
echo 'YOUR_MACOS_PASSWORD'
EOF
chmod 700 ~/.ssh/secrets/.supwd.sh
```

### mac install scripts

Machine-specific install scripts live in [`bash/macos/bin/`](bash/macos/bin/) (e.g. [`install-chad.sh`](bash/macos/bin/install-chad.sh)). Shared helpers are in [`bash/macos/lib/install-helpers.sh`](bash/macos/lib/install-helpers.sh).

Source libs in this order:

```bash
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${script_dir}/../lib/sudo-askpass.sh"
source "${script_dir}/../lib/install-helpers.sh"
```

`install-helpers.sh` provides `setup_brew_env`, `brew_bootstrap`, `brew_install_formula`, cask helpers (`brew_install_cask`, `brew_ensure_cask`, `brew_upgrade_force_cask`), `nvm_install_lts_prune`, `git_clone_or_pull`, `log_section`, and `brew_cleanup`. Cask helpers call `refresh_sudo` from `sudo-askpass.sh`.

To add a new machine, copy `install-chad.sh`, keep the shared lib sourcing and helper calls, and swap the package lists plus machine-specific libs (e.g. `copy-projects-chad.sh` → `copy-projects-lisa.sh`). Set `PACKAGE_MANAGE_LOG_PREFIX` before sourcing helpers to distinguish machines in logs.

### mac launchd (setup/update)

Use launchd to run the daily mac package workflow via [`run-package-manage.sh`](bash/macos/bin/run-package-manage.sh). The wrapper:

- prevents overlapping runs with a lock file at `bash/macos/state/package-manage.lock`
- uses `caffeinate` to keep the Mac awake during long installs
- refreshes sudo before cask installs
- writes start/finish markers to `bash/macos/logs/package-manage.log` for each phase (`launchd`, `install-chad.sh`, `Update-Modules-Mac.ps1`)

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
```

Manual run (same as scheduled launchd job)

Run the full daily workflow now with the same environment and logging as launchd (`git pull`, `install-chad.sh`, and `Update-Modules-Mac.ps1` via the wrapper):

```zsh
launchctl kickstart -k gui/$(id -u)/com.appfire-chadscribner.package-manage
```

Or run the wrapper directly:

```zsh
./bash/macos/bin/run-package-manage.sh
```

Verify and monitor logs

```zsh
launchctl print gui/$(id -u)/com.appfire-chadscribner.package-manage
tail -f ./bash/macos/logs/package-manage.log
tail -f ./bash/macos/logs/package-manage-launchd.log
```

A successful run ends with `launchd finish` in `package-manage.log`.

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
