# Non-package installations (add/update these first)

Get-Date -Format "dddd, MMMM dd, yyyy - hh:mm tt"
. $PSScriptRoot\Private\Install-Programs.ps1

Install-WinGetPackageClean -Id Lenovo.SystemUpdate
Install-WinGetPackageClean -Id NextDNS.NextDNS

# config

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"; `
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-default.json

. $PSScriptRoot\Private\Remove-Unwanted.ps1

# cleanup
choco uninstall choco-cleaner -y
