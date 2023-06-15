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

# node
Get-ChildItem "C:\ProgramData\nvm" | Where-Object { $_.PSIsContainer } | Where-Object { `
	$_.Name -ne "v10.24.1" -and `
	$_.Name -ne "v12.13.0" -and `
	$_.Name -ne "v16.14.0" -and `
	$_.Name -ne "v18.15.0"`
} | Remove-Item -Recurse

nvm install latest
nvm install 10.24.1
nvm install 12.13.0
nvm install 16.14.0
nvm install 18.15.0
nvm use latest

choco upgrade plexmediaserver -y
choco upgrade rpi-imager -y
choco upgrade win32diskimager --version 0.9.5 -y
choco pin add --name="'win32diskimager'" --version="'0.9.5'"

choco feature enable -n useRememberedArgumentsForUpgrades
choco upgrade all -y

$Desktops = "$env:PUBLIC\Desktop", "$env:USERPROFILE\Desktop"

If ($null -ne $StartTime) {
	$Desktops | Get-ChildItem -Filter "*.lnk" -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -gt $StartTime } | Remove-Item
}
