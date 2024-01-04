# Non-Chocolatey installations (add/update these first)
# chocolatey itself
# git-sdk (uninstall once pacman is scriptable)
# googledrive
# microsoft-windows-terminal
# winget

# Registry

# Google Chrome - remote access Curtain Mode
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome", "RemoteAccessHostRequireCurtain", 1)
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server", "fDenyTSConnections", 0)
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp", "UserAuthentication", 0)
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp", "SecurityLayer", 1)

# Lock Screen - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization", "NoLockScreen", 1)

# Open With - always fix
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppXk0g4vb8gvt7b93tg50ybcy892pge6jmt" –Name "NoOpenWith"  -ErrorAction SilentlyContinue
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" –Name "NoOpenWith"  -ErrorAction SilentlyContinue
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppX9rkaq77s0jzh1tyccadx9ghba15r6t3h" –Name "NoOpenWith"  -ErrorAction SilentlyContinue
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" –Name "NoOpenWith"  -ErrorAction SilentlyContinue
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" –Name "NoOpenWith"  -ErrorAction SilentlyContinue

# Modern Standby - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power", "PlatformAoAcOverride", 0)

# Start back up - remove
Remove-ItemProperty –Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StorageProvider\OneDrive" –Name "StorageProviderKnownFolderSyncInfoSourceFactory"  -ErrorAction SilentlyContinue

# Start Menu - disable Bing Search
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer", "DisableSearchBoxSuggestions", 1)

# Task Manager - enable
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\4\1887869580", "EnabledState", 2)

# Windows - old right-click
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32", "", "")

$env:Path += ';C:\Program Files\Git\bin'
choco upgrade chocolatey -y
$Outdated = choco outdated -r

# pacman
If (-Not (Test-Path "C:\Program Files\Git\usr\bin\pacman.exe") -and (Test-Path "C:\git-sdk-64\usr\bin\pacman.exe")) {
	Copy-Item "C:\git-sdk-64\usr\bin\pacman.exe" -Destination "C:\Program Files\Git\usr\bin"
	Copy-Item "C:\git-sdk-64\etc\pacman.conf" -Destination "C:\Program Files\Git\etc"
	Copy-Item -Recurse "C:\git-sdk-64\etc\pacman.d" -Destination "C:\Program Files\Git\etc"
	Copy-Item -Recurse "C:\git-sdk-64\var" -Destination "C:\Program Files\Git"
}

Invoke-Expression "bash.exe -c -i `"pacman -S --noconfirm pacman`""

choco upgrade curl -y

# git
choco upgrade git -y
git config --global http.sslBackend openssl

choco upgrade 7zip -y
choco upgrade adb -y
choco upgrade agentransack -y
choco upgrade bulkrenameutility -y
choco upgrade chrome-remote-desktop-chrome -y
choco upgrade chrome-remote-desktop-host -y

# clink
choco upgrade clink-maintained -y
cmd.exe /c "`"C:\Program Files (x86)\clink\clink`" update /S"
cmd.exe /c "`"C:\Program Files (x86)\clink\clink`" autorun uninstall"

choco upgrade cutepdf -y
choco upgrade dvddecrypter -y
choco upgrade instanteyedropper.app -y
choco upgrade ffmpeg -y
choco upgrade filezilla -y
choco upgrade firefox -y --params "/NoTaskbarShortcut /NoDesktopShortcut"
choco upgrade freefilesync -y
choco upgrade ghostscript -y
choco upgrade googlechrome -y --ignore-checksums -y
choco upgrade gimp -y
choco upgrade github-desktop -y
choco upgrade guiformat -y
choco upgrade handbrake -y
choco upgrade hxd -y
choco upgrade imagemagick.app -y
choco upgrade imgburn -y
choco upgrade inkscape -y
choco upgrade irfanview -y
choco upgrade irfanviewplugins -y
choco upgrade itunes -y
choco upgrade kitty --version 0.76.1.9 -y
choco pin add --name="'kitty'" --version="'0.76.1.9'"
choco upgrade libreoffice-still -y
choco upgrade linux-reader -y
choco upgrade lsd -y
choco upgrade microsoft-teams -y
choco upgrade mp3tag -y
choco upgrade nextdns -y

# nerd-fonts
choco upgrade nerd-fonts-meslo -y
robocopy  C:\Windows\Fonts "$Env:USERPROFILE\Fonts Backup" /XO

choco upgrade notepadplusplus -y
choco upgrade onedrive --ignore-checksums -y

# oh-my-posh
choco upgrade oh-my-posh -y
oh-my-posh disable notice

choco upgrade paint.net -y
choco upgrade pngquant -y
choco upgrade pngyu -y

# powershell-core
choco upgrade powershell-core -y
Install-Module posh-git -Force
Install-Module PSReadLine -AllowPrerelease -Force
Install-Module -Name Terminal-Icons -Repository PSGallery -Force

choco upgrade powertoys -y

# ps-sfta - file type associations
$GitDir = "C:\PS-SFTA"
$GitUrl = "https://github.com/DanysysTeam/PS-SFTA.git"
$Clone = $FALSE

If (-Not (Test-Path -Path $GitDir)) {
	$Clone = $TRUE
} Else {
	Set-Location $GitDir
	git fetch
	$GitMain = git rev-parse master
	$GitOrigin = git rev-parse origin/master
	Set-Location -

	If ($GitMain -ne $GitOrigin) {
		Remove-Item -Recurse -Force $GitDir
		$Clone = $TRUE
	}
}

If ($Clone) {
	git clone $GitUrl $GitDir
}

. $GitDir\SFTA.ps1
Set-FTA IrfanView.gif .gif
Set-FTA IrfanView.jpg .jpeg
Set-FTA IrfanView.jpg .jpg
Set-FTA IrfanView.png .png
Set-FTA IrfanView.tif .tif
Set-FTA VLC.mp3 .mp3
Set-FTA VLC.mpeg .mpeg

choco upgrade puretext -y

# python
If ($Outdated -match "python") {
	choco uninstall python python3 -y
}

choco upgrade python -y
python -m pip install -U pip
choco upgrade quicktime -y

# ruby
If ($Outdated -match "ruby") {
	choco uninstall ruby -y
	choco uninstall ruby.install -y
}

choco upgrade ruby -y

choco upgrade scribus -y
choco upgrade sharpkeys -y
choco upgrade sqlitebrowser -y

# perl
choco upgrade strawberryperl -y
cpanm -n Perl::LanguageServer

choco upgrade sumatrapdf -y
choco upgrade tftpd32 -y
choco upgrade vlc -y
choco upgrade vim -y --params "'/NoDesktopShortcuts'"
choco upgrade vscode -y --params "/NoDesktopIcon"
choco upgrade winmerge -y
choco upgrade xmlstarlet -y
choco upgrade yt-dlg.portable -y
choco upgrade zoom -y

# zsh
Invoke-Expression "bash.exe -c -i `"pacman -S --needed --noconfirm --overwrite \* zsh`""

$GitDir = "$Env:USERPROFILE\.zsh\zsh-autosuggestions"

If (Test-Path -Path $GitDir) {
	Set-Location $GitDir
	git fetch
	$GitMain = git rev-parse master
	$GitOrigin = git rev-parse origin/master
	Set-Location -

	If ($GitMain -ne $GitOrigin) {
		Remove-Item -Recurse -Force $GitDir
	}
}

$GitDir = "$Env:USERPROFILE\.zsh\zsh-syntax-highlighting"

If (Test-Path -Path $GitDir) {
	Set-Location $GitDir
	git fetch
	$GitMain = git rev-parse master
	$GitOrigin = git rev-parse origin/master
	Set-Location -

	If ($GitMain -ne $GitOrigin) {
		Remove-Item -Recurse -Force $GitDir
	}
}

Get-ChildItem $HOME | Where-Object { $_.Name -match '^\.zsh_history\..+' } | Where-Object LastWriteTime -lt  (Get-Date).AddDays(-5) | Remove-Item

# delete pesky desktop shortcuts
$Desktops = "$env:PUBLIC\Desktop", "$env:USERPROFILE\Desktop"

$Desktops | Get-ChildItem -Filter "BlueStacks 5.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "BlueStacks Multi-Instance Manager.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "BlueStacks X.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "Canon IJ Network Tool.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "Chrome Remote Desktop.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "DB Browser (SQLCipher).lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "DB Browser (SQLite).lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "DB Browser *.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "DiskInternals Research.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "DVD Decrypter.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "DVD Flick.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "FlashPrint-MP.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "FreeFileSync.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "GitHub Desktop.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "Google Chrome.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "ImageMagick Display.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "ImgBurn.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "Inkscape.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "Instant Eyedropper.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "iTunes.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "LibreOffice *.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "MakeMKV.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "Microsoft Edge.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "Mp3tag.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "paint.net.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "Paragon Partition Manager™ 14 Free.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "QuickTime Player.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "RealTimeSync.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "Redragon K556RGB Keyboard.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "Roblox Player.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "Roblox Studio.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "ScanSnap Home.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "Scribus *.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "Scribus 1.4.8.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "SharpKeys.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "SumatraPDF.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "VLC media player.lnk" -ErrorAction SilentlyContinue | Remove-Item
$Desktops | Get-ChildItem -Filter "Zoom.lnk" -ErrorAction SilentlyContinue | Remove-Item

. $PSScriptRoot\_ChocoDefaultConfig.ps1
