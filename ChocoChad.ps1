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

choco upgrade barrier -y
choco upgrade dvdflick-v2 -y
choco upgrade makemkv -y
choco upgrade nvidia-display-driver -y
choco upgrade plexmediaserver -y
choco upgrade rpi-imager -y
choco upgrade win32diskimager --version 0.9.5 -y
choco pin add --name="'win32diskimager'" --version="'0.9.5'"

choco feature enable -n useRememberedArgumentsForUpgrades
choco upgrade all -y

If ($null -ne $StartTime) {
	$Desktops = "$env:PUBLIC\Desktop", "$env:USERPROFILE\Desktop"
	$Desktops | Get-ChildItem -Filter "*.lnk" -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -gt $StartTime } | Remove-Item
}
