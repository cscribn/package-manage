# Non-package installations (add/update these first)
# backblaze

[CmdletBinding()]
$Global:InformationPreference = 'Continue'

Get-Date -Format "dddd, MMMM dd, yyyy - hh:mm tt"

. $PSScriptRoot\Private\Set-Registry.ps1
. $PSScriptRoot\Private\Install-Helpers.ps1
. $PSScriptRoot\Private\Install-Programs-Elevated.ps1
. $PSScriptRoot\Private\Install-Apps-Elevated.ps1
. $PSScriptRoot\Private\Copy-Config.ps1

# config

## microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"
Copy-Item -Path "$Env:USERPROFILE\.config\dotfiles-misc\microsoft-windows-terminal/LocalState/settings-default.json" -Destination "$LocalStateDir\settings.json" -Force

. $PSScriptRoot\Private\Remove-Unwanted.ps1
. $PSScriptRoot\Private\Reset-Network.ps1
