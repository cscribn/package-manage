# package-manage

Scripts beginning with "_" are meant to be included in other scripts.

## apt*

Bash scripts that call apt to install Raspberry Pi packages. Different files are used for different machines.

## brew-work

Bash script that calls brew to install Mac OS packages on my work machine.

## Choco*

Powershell scripts that call Chocolatey to install Windows packages. Different files are used for different machines.

## Prerequisites

Install Chocolatey via PowerShell

```pwsh
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Install PowerShell Core via PowerShell

```pwsh
winget install --id Microsoft.Powershell --source winget
```

Unrestrict the Execution Policy in PowerShell Core

```pwsh
Set-ExecutionPolicy Unrestricted
```

Run all scripts using PowerShell Core
