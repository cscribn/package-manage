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
