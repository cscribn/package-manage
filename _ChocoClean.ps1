$Desktops = "$env:PUBLIC\Desktop", "$env:USERPROFILE\Desktop"
$Desktops | Get-ChildItem -Filter "*.lnk" -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -gt $StartTime } | Remove-Item
