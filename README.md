# package-manage

Scripts beginning with "_" are meant to be included in other scripts.

## apt*

Bash scripts that call apt to install Raspberry Pi packages. Different files are used for different machines.

### Prerequisites

Install brew via Terminal

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Choco*

Powershell scripts that call Chocolatey to install Windows packages. Different files are used for different machines.

### Prerequisites

Install Chocolatey via PowerShell

```pwsh
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Download and install the lates PowerShell Core release from [GitHub](https://github.com/PowerShell/PowerShell/releases).

Unrestrict the Execution Policy in PowerShell Core

```pwsh
Set-ExecutionPolicy Unrestricted
```

Run all scripts using PowerShell Core
