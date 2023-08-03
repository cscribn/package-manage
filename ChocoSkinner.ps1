# Non-Chocolatey installations (add/update these first)
# backblaze
# bluestacks
# iso compressor
# skraperui

. $PSScriptRoot\_ChocoDefault.ps1

choco upgrade barrier -y
choco upgrade dvdflick-v2 -y
choco upgrade makemkv -y
choco upgrade rpi-imager -y
choco upgrade win32diskimager --version 0.9.5 -y
choco pin add --name="'win32diskimager'" --version="'0.9.5'"

choco feature enable -n useRememberedArgumentsForUpgrades
choco upgrade all -y
