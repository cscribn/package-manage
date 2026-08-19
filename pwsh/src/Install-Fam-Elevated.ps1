[CmdletBinding()]
$Global:InformationPreference = 'Continue'

Get-Date -Format "dddd, MMMM dd, yyyy - hh:mm tt"

. $PSScriptRoot\Private\Set-Registry.ps1
. $PSScriptRoot\Private\Install-Programs-Elevated.ps1
. $PSScriptRoot\Private\Install-Apps-Elevated.ps1

# config

## microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"
curl -sSLo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-default.json

. $PSScriptRoot\Private\Copy-Config.ps1
. $PSScriptRoot\Private\Remove-Unwanted.ps1
. $PSScriptRoot\Private\Reset-Network.ps1
