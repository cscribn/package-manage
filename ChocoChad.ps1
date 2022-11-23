# Non-Chocolatey installations (add/update these first)
# backblaze
# bluestacks
# iso compressor
# papercut mobility print
# skraperui

. $PSScriptRoot\_ChocoDefault.ps1
. $PSScriptRoot\_ChocoDev.ps1

choco upgrade barrier -y
choco upgrade dvdflick-v2 -y
choco upgrade makemkv -y
choco upgrade nvidia-display-driver -y
choco upgrade plexmediaserver -y
choco upgrade rpi-imager -y
choco upgrade win32diskimager --version 0.9.5 -y
choco pin add --name="'win32diskimager'" --version="'0.9.5'"
