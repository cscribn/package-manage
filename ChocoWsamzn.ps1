$StartTime = Get-Date
. $PSScriptRoot\_ChocoDefault.ps1

choco upgrade awscli -y

# conemu
choco upgrade conemu -y

curl -Lo "$Env:APPDATA\ConEmu.xml" https://raw.githubusercontent.com/cscribn/config-misc/main/conemu/ConEmu.xml

choco upgrade pnpm -y
choco upgrade postman -y

choco feature enable -n useRememberedArgumentsForUpgrades
choco upgrade all -y

# clean desktop shortcuts
If ($null -ne $StartTime) {
	$Desktops = "$env:PUBLIC\Desktop", "$env:USERPROFILE\Desktop"
	$Desktops | Get-ChildItem -Filter "*.lnk" -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -gt $StartTime } | Remove-Item
}
