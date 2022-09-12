. $PSScriptRoot\_ChocoDefault.ps1
. $PSScriptRoot\_ChocoDev.ps1

choco upgrade conemu -y
choco upgrade nvm -y
choco upgrade postman -y

upgrade all -y
