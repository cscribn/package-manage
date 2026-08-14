# Non-package installations (add/update these first)
# awesome duplicate photo finder
# backblaze
# krita generative AI - https://github.com/Acly/krita-ai-diffusion
# scansnap
# silhouette studio

Get-Date -Format "dddd, MMMM dd, yyyy - hh:mm tt"
. $PSScriptRoot\Private\Install-Programs.ps1

Install-WinGetPackageClean -Id BlueStack.BlueStacks
Install-WinGetPackageClean -Id fotor.fotor
Install-WinGetPackageClean -Id Google.GoogleDrive
Install-WinGetPackageClean -Id KDE.Krita
Install-WinGetPackageClean -Id NextDNS.NextDNS
Install-WinGetPackageClean -Id Poly.PlantronicsHub

# config

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"; `
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-default.json

. $PSScriptRoot\Private\Remove-Unwanted.ps1

# cleanup
choco upgrade choco-cleaner --params "'/NOTASK:TRUE'" -y --ignore-dependencies; Start-Process -FilePath "C:\ProgramData\chocolatey\bin\choco-cleaner.bat" -Wait
