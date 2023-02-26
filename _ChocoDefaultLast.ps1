choco upgrade all -y

If ($StartTime -ne $null) {
	$Desktops = "$env:PUBLIC\Desktop", "$env:USERPROFILE\Desktop"
	$Desktops | Get-ChildItem -Filter "*.lnk" -ErrorAction SilentlyContinue | Where-Object { $_.CreationTime -gt $StartTime } | Remove-Item
}
