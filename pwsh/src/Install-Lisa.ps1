# Non-package installations (add/update these first)
# awesome duplicate photo finder
# backblaze
# krita generative AI - https://github.com/Acly/krita-ai-diffusion
# scansnap
# silhouette studio

Get-Date -Format "dddd, MMMM dd, yyyy - hh:mm tt"

. $PSScriptRoot\Private\Set-Registry.ps1
. $PSScriptRoot\Private\Install-Programs.ps1
. $PSScriptRoot\Private\Install-Apps.ps1

# winget
Install-WinGetPackageClean -Id BlueStack.BlueStacks
Install-WinGetPackageClean -Id fotor.fotor
Install-WinGetPackageClean -Id Google.GoogleDrive
Install-WinGetPackageClean -Id KDE.Krita
Install-WinGetPackageClean -Id NextDNS.NextDNS
Install-WinGetPackageClean -Id Poly.PlantronicsHub

# config

## microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"
curl -sSLo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-default.json

. $PSScriptRoot\Private\Copy-Config.ps1
. $PSScriptRoot\Private\Remove-Unwanted.ps1
. $PSScriptRoot\Private\Reset-Network.ps1
