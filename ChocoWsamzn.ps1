. $PSScriptRoot\_ChocoDefault.ps1
. $PSScriptRoot\_ChocoDev.ps1

# conemu
choco upgrade conemu -y
Set-Location "$Env:APPDATA"

curl -Lo "ConEmu.xml" https://raw.githubusercontent.com/cscribn/config-misc/main/conemu/ConEmu.xml

Set-Location -

choco upgrade nvm -y
choco upgrade postman -y

choco upgrade all -y
