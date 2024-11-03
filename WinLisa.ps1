# Non-package installations (add/update these first)
# awesome duplicate photo finder
# backblaze
# scansnap
# silhouette studio

. $PSScriptRoot\_WinDefaultFirst.ps1

winget install -e --id BlueStack.BlueStacks
winget install -e --id fotor.fotor
winget install -e --id Google.GoogleDrive
winget install -e --id Lenovo.SystemUpdate
winget install -e --id NextDNS.NextDNS.Desktop
winget install -e --id Poly.PlantronicsHub

# config

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"; `
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-default.json

. $PSScriptRoot\_WinDefaultLast.ps1

# cleanup
choco upgrade choco-cleaner --params "'/NOTASK:TRUE'" -y --ignore-dependencies; Start-Process -FilePath "C:\ProgramData\chocolatey\bin\choco-cleaner.bat" -Wait
