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
