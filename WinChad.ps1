# Non-package installations (add/update these first)
# append C:\jdk to PATH
# backblaze
# mise (first install only from https://github.com/jdx/mise/releases)
# iso compressor
# skraperui

. $PSScriptRoot\_WinDefaultFirst.ps1

choco upgrade iconsext -y --ignore-dependencies; choco upgrade iconsext.install -y --ignore-dependencies
choco upgrade pngquant -y --ignore-dependencies
choco upgrade pngyu -y --ignore-dependencies
choco upgrade tftpd32 -y --ignore-dependencies
choco upgrade win32diskimager --version 0.9.5 -y --ignore-dependencies; choco pin add --name="'win32diskimager'" --version="'0.9.5'"
choco upgrade xmlstarlet -y --ignore-dependencies; choco upgrade xmlstarlet.portable -y --ignore-dependencies
choco upgrade xsltproc -y --ignore-dependencies

winget install -e --id Balena.Etcher
winget install -e --id BlueStack.BlueStacks
winget install -e --id DBBrowserForSQLite.DBBrowserForSQLite
winget install -e --id DBeaver.DBeaver.Community

if ((Get-WinGetPackage -Name "Barrier").Count -eq 0) { `
	winget install -e --id DebaucheeOpenSourceGroup.Barrier `
}

winget install -e --id Docker.DockerDesktop
winget install -e --id DVDFlick.DVDFlick

if ((Get-WinGetPackage -Name "DiskGenius").Count -eq 0) { `
    winget install -e --id Eassos.DiskGenius `
}

winget install -e --id direnv.direnv

# java
if ((Get-WinGetPackage -Name JDK).Count -gt 1) { `
    $Id = Get-WinGetPackage -Name JDK | Sort-Object Id | Select-Object -ExpandProperty Id | Select-Object -First 1; winget uninstall -e --id $Id `
} `
$Id = Find-WinGetPackage EclipseAdoptium.Temurin | Where-Object { $_.Version -match '^\d+(\.\d+)*$' } | Sort-Object -Property { [version]$_.Version } | Select-Object -Last 2 | Select-Object -First 1 -ExpandProperty Id; winget install -e --id $Id

# jdk shortcut
$target = Get-ChildItem "C:\Program Files\Eclipse Adoptium" | `
    Sort-Object Name | `
    Select-Object -Last 1; `
if ($target) { `
    New-Item -ItemType SymbolicLink -Path "C:\jdk" -Target $target.FullName -Force `
}

winget install -e --id Fastfetch-cli.Fastfetch
winget install -e --id GitHub.GitHubDesktop
winget install -e --id Google.GoogleDrive
winget install -e --id GuinpinSoft.MakeMKV
winget install -e --id ImageMagick.ImageMagick
winget install -e --id MHNexus.HxD

# microsoft (c++) buildtools
if ((Get-WinGetPackage -Name BuildTools).Count -gt 1) { `
    $Id = Get-WinGetPackage -Name BuildTools | Sort-Object Id | Select-Object -ExpandProperty Id | Select-Object -First 1; winget uninstall -e --id $Id `
} `
$Id = Find-WinGetPackage BuildTools | Where-Object { $_.Version -match '^\d+(\.\d+)*$' } | Sort-Object -Property { [version]$_.Version } | Select-Object -Last 1 -ExpandProperty Id; winget install -e --id $Id

winget install -e --id NextDNS.NextDNS

# node
winget install -e --id CoreyButler.NVMforWindows; `
nvm install lts; nvm use lts
# remove old node versions
Get-ChildItem $env:NVM_HOME -Directory | Sort-Object Name -Descending | Select-Object -Skip 1 | ForEach-Object { nvm uninstall $_.Name }

winget install -e --id Oracle.VirtualBox
winget install -e --id Poly.PlantronicsHub
winget install -e --id Postman.Postman
winget install -e --id PuTTY.PuTTY

# python
if ((Get-WinGetPackage Python.Python).Count -gt 1) { `
    $Id = Get-WinGetPackage Python.Python | Sort-Object Id | Select-Object -ExpandProperty Id | Select-Object -First 1; winget uninstall -e --id $Id `
} `
$Id = Find-WinGetPackage Python.Python. | Where-Object { $_.Version -match '^\d+(\.\d+)*$' } | Sort-Object -Property { [version]$_.Version } | Select-Object -Last 1 -ExpandProperty Id; winget install -e --id $Id; `
python -m pip install -U pip

# python packages
pip install --upgrade scour --ignore-requires-python
pip install --upgrade spotdl --ignore-requires-python

winget install -e --id RaspberryPiFoundation.RaspberryPiImager
winget install -e --id Rufus.Rufus
winget install -e --id SBCL.SBCL # steel bank common lisp
winget install -e --id sharkdp.bat
winget install -e --id SQLite.SQLite
winget install -e --id srjuddington.slade
winget install -e --id WireGuard.WireGuard

# wsl
if (-Not (wsl --list -version)) { wsl --install }; `
wsl -d "Ubuntu" -u root -e apt update -y; `
wsl -d "Ubuntu" -u root -e apt install expect -y; `
wsl -d "Ubuntu" -u root -e apt full-upgrade -y; `
wsl -d "Ubuntu" -u root -e do-release-upgrade; `
wsl -d "Ubuntu" -u root -e apt autoremove -y; `
wsl -d "Ubuntu" -u root -e apt clean -y

# config

# barrier restart
Stop-Service -Name "Barrier" -Force; Start-Service -Name "Barrier"

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"; `
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-chad.json

. $PSScriptRoot\_WinDefaultLast.ps1

# file types
Set-FTA Applications\notepad++.exe .txt

# cleanup
choco upgrade choco-cleaner --params "'/NOTASK:TRUE'" -y --ignore-dependencies; Start-Process -FilePath "C:\ProgramData\chocolatey\bin\choco-cleaner.bat" -Wait
if (docker info > $null 2>&1) { docker system prune --volumes -f }

. $PSScriptRoot\_WinDefaultGaming.ps1
