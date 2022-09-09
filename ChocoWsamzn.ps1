# upgrade all -y

. $PSScriptRoot\_ChocoDefault.ps1
. $PSScriptRoot\_ChocoDev.ps1

choco upgrade conemu -y
choco upgrade nvm -y
choco upgrade postman -y
choco upgrade googledrive -y
