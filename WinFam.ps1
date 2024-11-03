# Non-package installations (add/update these first)

. $PSScriptRoot\_WinDefaultFirst.ps1

choco upgrade hyperx-ngenuity -y --ignore-dependencies

winget install -e --id EpicGames.EpicGamesLauncher
winget install -e --id Lenovo.SystemUpdate
winget install -e --id NextDNS.NextDNS.Desktop
winget install -e --id Open-Shell.Open-Shell-Menu
winget install -e --id Valve.Steam
winget install -e --id TechNobo.TcNoAccountSwitcher

# config

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"; `
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-default.json

. $PSScriptRoot\_WinDefaultLast.ps1

# cleanup
choco upgrade choco-cleaner --params "'/NOTASK:TRUE'" -y --ignore-dependencies; Start-Process -FilePath "C:\ProgramData\chocolatey\bin\choco-cleaner.bat" -Wait
