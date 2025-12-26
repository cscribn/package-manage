# package-manage

* Scripts beginning with "_" are meant to be included in other scripts.
* Scripts are formatted to ease copying/pasting single lines. The code is therefore not DRY and sometimes lines are long running.

## pi* & ubuntu*

Bash scripts that install/upgrade Raspberry Pi/Ubuntu packages. Different files are used for different machines.

## mac*

Bash scripts that install/upgrade Mac packages.

### Prerequisites

Install brew via Terminal

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Win*

Powershell scripts that install/upgrade Windows packages. Different files are used for different machines.

### Prerequisites

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
