# Non-Chocolatey installations (add/update these first)
# alienware update universal
# backblaze
# bluestacks
# iso compressor
# papercut mobility print
# samsung magician
# skraperui

$StartTime = Get-Date
. $PSScriptRoot\_ChocoDefault.ps1

choco upgrade nvidia-display-driver -y
choco upgrade plexmediaserver -y

choco feature enable -n useRememberedArgumentsForUpgrades
choco upgrade all -y

$Desktops = "$env:PUBLIC\Desktop", "$env:USERPROFILE\Desktop"

If ($null -ne $StartTime) {
	$Desktops | Get-ChildItem -Filter "*.lnk" -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -gt $StartTime } | Remove-Item
}
