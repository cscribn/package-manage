. $PSScriptRoot\_ChocoDefault.ps1
. $PSScriptRoot\_ChocoDev.ps1

choco upgrade barrier -y
choco upgrade chrome-remote-desktop-chrome -y
choco upgrade chrome-remote-desktop-host -y
choco upgrade dvdflick-v2 -y
# manual: iso compressor
choco upgrade makemkv -y
choco upgrade mp3tag -y
choco upgrade nvidia-display-driver -y
choco upgrade plexmediaserver -y
choco upgrade rpi-imager -y
# manual: skraperui
choco upgrade youtube-dl-gui -y
choco upgrade win32diskimager --version 0.9.5 -y
choco pin add --name="'win32diskimager'" --version="'0.9.5'"

upgrade all -y
