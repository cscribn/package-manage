# Non-Chocolatey installations (add/update these first)
# lenovo vangate
# samsung magician

. $PSScriptRoot\_ChocoDefault.ps1

choco upgrade epicgameslauncher -y
choco upgrade nvidia-display-driver -y
choco upgrade steam-client -y

. $PSScriptRoot\_ChocoLast.ps1
