# Non-package installations (add/update these first)
# backblaze
# iso compressor
# skraperui
# spotdl

. $PSScriptRoot\_WinDefaultFirst.ps1

winget install -e --id DebaucheeOpenSourceGroup.Barrier
winget install -e --id sharkdp.bat
winget install -e --id BlueStack.BlueStacks
choco upgrade dbeaver -y
choco upgrade dvdflick-v2 -y
winget install -e --id Fastfetch-cli.Fastfetch
choco upgrade github-desktop -y
winget install -e --id Google.GoogleDrive
choco upgrade hxd -y
winget install -e --id ImageMagick.ImageMagick
choco upgrade kitty -y
choco upgrade makemkv -y
choco upgrade nextdns -y
winget install -e --id Poly.PlantronicsHub # plantronics hub
choco upgrade postman -y

# python
if ((Get-WinGetPackage -Name Python).Count -gt 1) { `
    $Id = (Get-WinGetPackage -Name Python).Id | Select-Object -First 1; winget uninstall -e --id $Id `
} `
$Id = Find-WinGetPackage Python.Python | Where-Object { $_.Version -match '^\d+(\.\d+)*$' } | Sort-Object -Property { [version]$_.Version } | Select-Object -Last 1 -ExpandProperty Id; winget install -e --id $Id; `
python -m pip install -U pip

choco upgrade rpi-imager -y

# ruby
if ((Get-WinGetPackage -Name Ruby).Count -gt 1) { `
    $Id = (Get-WinGetPackage -Name Ruby).Id | Select-Object -First 1; winget uninstall -e --id $Id `
} `
$Id = (Find-WinGetPackage RubyInstallerTeam.Ruby).Id | Select-Object -Last 1; winget install -e --id $Id

choco upgrade wireguard -y
choco upgrade win32diskimager --version 0.9.5 -y
choco pin add --name="'win32diskimager'" --version="'0.9.5'"
choco upgrade xmlstarlet -y --ignore-dependencies
choco upgrade xmlstarlet.portable -y --ignore-dependencies

# config

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"; `
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-chad.json

. $PSScriptRoot\_WinDefaultLast.ps1
