# Non-package installations (add/update these first)
# backblaze
# iso compressor
# skraperui

. $PSScriptRoot\_WinDefaultFirst.ps1

choco upgrade iconsext -y --ignore-dependencies
choco upgrade iconsext.install -y --ignore-dependencies
choco upgrade pngquant -y --ignore-dependencies
choco upgrade pngyu -y --ignore-dependencies
choco upgrade tftpd32 -y --ignore-dependencies
choco upgrade win32diskimager --version 0.9.5 -y --ignore-dependencies
choco pin add --name="'win32diskimager'" --version="'0.9.5'"
choco upgrade xmlstarlet -y --ignore-dependencies
choco upgrade xmlstarlet.portable -y --ignore-dependencies

winget install -e --id DebaucheeOpenSourceGroup.Barrier
winget install -e --id sharkdp.bat
winget install -e --id BlueStack.BlueStacks
winget install -e --id dbeaver.dbeaver
winget install -e --id DVDFlick.DVDFlick
winget install -e --id Fastfetch-cli.Fastfetch
winget install -e --id GitHub.GitHubDesktop
winget install -e --id Google.GoogleDrive
winget install -e --id Lenovo.SystemUpdate
winget install -e --id MHNexus.HxD
winget install -e --id ImageMagick.ImageMagick
winget install -e --id GuinpinSoft.MakeMKV
winget install -e --id NextDNS.NextDNS.Desktop
winget install -e --id Poly.PlantronicsHub
winget install -e --id Postman.Postman

# python
if ((Get-WinGetPackage -Name Python).Count -gt 1) { `
    $Id = (Get-WinGetPackage -Name Python).Id | Select-Object -First 1; winget uninstall -e --id $Id `
} `
$Id = Find-WinGetPackage Python.Python | Where-Object { $_.Version -match '^\d+(\.\d+)*$' } | Sort-Object -Property { [version]$_.Version } | Select-Object -Last 1 -ExpandProperty Id; winget install -e --id $Id; `
python -m pip install -U pip

winget install -e --id RaspberryPiFoundation.RaspberryPiImager
winget install -e --id WireGuard.WireGuard

# spotdl
New-Item -ItemType Directory -Force -Path "C:\spotdl" | Out-Null; `
$Destination = "C:\spotdl\spotdl-latest-win32.exe"; `
if (Test-Path $Destination) { `
    $FileAge = (Get-Item $Destination).LastWriteTime; `
} else { `
    $FileAge = (Get-Date -Year 1970 -Month 1 -Day 1 -Hour 0 -Minute 0 -Second 0 -Millisecond 0); `
}; `
$CurrentDate = Get-Date; `
$DaysOld = ($CurrentDate - $FileAge).Days; `
if ($DaysOld -ge 7) { `
    $Response = Invoke-RestMethod -Uri "https://api.github.com/repos/spotDL/spotify-downloader/releases/latest"; `
    $DownloadUrl = $Response.assets | Where-Object { $_.browser_download_url -match "spotdl-.*-win32.exe" } | Select-Object -ExpandProperty browser_download_url; `
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $Destination; `
}

# config

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"; `
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-chad.json

. $PSScriptRoot\_WinDefaultLast.ps1
