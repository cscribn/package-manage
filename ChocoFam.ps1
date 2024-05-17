# Non-Chocolatey installations (add/update these first)
# lenovo vantage
# tcno account switcher

. $PSScriptRoot\_ChocoDefaultFirst.ps1

choco upgrade hyperx-ngenuity -y
choco upgrade epicgameslauncher -y
choco upgrade steam-client -y

# config

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"

curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/config-misc/main/microsoft-windows-terminal/LocalState/settings-default.json

. $PSScriptRoot\_ChocoDefaultLast.ps1
