. $PSScriptRoot\_ChocoDefault.ps1
. $PSScriptRoot\_ChocoDev.ps1

# conemu
choco upgrade conemu -y

curl -Lo "$Env:APPDATA\ConEmu.xml" https://raw.githubusercontent.com/cscribn/config-misc/main/conemu/ConEmu.xml

choco upgrade postman -y

. $PSScriptRoot\_ChodoDefaultLast.ps1
