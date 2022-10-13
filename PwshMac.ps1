Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module posh-git -Force
Install-Module PSReadLine -AllowPrerelease -Force

curl -Lo "$HOME/.config/powershell/Microsoft.PowerShell_profile.ps1" https://raw.githubusercontent.com/cscribn/config-misc/main/powershell-core/Microsoft.PowerShell_profile.ps1
