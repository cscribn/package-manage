# Non-Chocolatey installations (add/update these first)
# lenovo vantage
# samsung magician

$StartTime = Get-Date
. $PSScriptRoot\_ChocoDefault.ps1

choco upgrade hyperx-ngenuity -y
choco upgrade epicgameslauncher -y
choco upgrade steam-client -y

If ($null -ne $StartTime) {
	$Desktops = "$env:PUBLIC\Desktop", "$env:USERPROFILE\Desktop"
	$Desktops | Get-ChildItem -Filter "*.lnk" -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -gt $StartTime } | Remove-Item
}
