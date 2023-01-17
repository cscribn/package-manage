# Non-Chocolatey installations (add/update these first)
# lenovo vantage
# samsung magician

. $PSScriptRoot\_ChocoDefault.ps1
. $PSScriptRoot\_ChocoDefaultConfig.ps1

choco upgrade hyperx-ngenuity -y
choco upgrade epicgameslauncher -y
choco upgrade steam-client -y

. $PSScriptRoot\_ChodoDefaultLast.ps1
