# Non-Chocolatey installations (add/update these first)
# chocolatey itself
# freefilesync
# git-sdk (uninstall once pacman is scriptable)
# googledrive
# microsoft-windows-terminal

# Registry

# Google Chrome - remote access Curtain Mode
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome", "RemoteAccessHostRequireCurtain", 1)
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server", "fDenyTSConnections", 0)
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp", "UserAuthentication", 0)
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp", "SecurityLayer", 1)

# Lock Screen - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization", "NoLockScreen", 1)

# Prevent file association reset - Photos
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppXk0g4vb8gvt7b93tg50ybcy892pge6jmt" –Name "NoOpenWith"  -ErrorAction SilentlyContinue
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" –Name "NoOpenWith"  -ErrorAction SilentlyContinue
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppX9rkaq77s0jzh1tyccadx9ghba15r6t3h" –Name "NoOpenWith"  -ErrorAction SilentlyContinue

# Prevent file association reset - Music
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" –Name "NoOpenWith"  -ErrorAction SilentlyContinue

# Prevent file association reset - Video
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" –Name "NoOpenWith"  -ErrorAction SilentlyContinue

# Modern Standby - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power", "PlatformAoAcOverride", 0)

# Start Menu - disable Internet search
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer", "DisableSearchBoxSuggestions", 1)

# Task Manager - enable
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\4\1887869580", "EnabledState", 2)

# Windows - old right-click
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32", "", "")

$env:Path += ';C:\Program Files\Git\bin'
choco upgrade chocolatey -y
$Outdated = choco outdated -r

# pacman
If (-Not (Test-Path "C:\Program Files\Git\usr\bin\pacman.exe") -and (Test-Path "C:\git-sdk-64\usr\bin\pacman.exe")) { `
	Copy-Item "C:\git-sdk-64\usr\bin\pacman.exe" -Destination "C:\Program Files\Git\usr\bin"; `
	Copy-Item "C:\git-sdk-64\etc\pacman.conf" -Destination "C:\Program Files\Git\etc"; `
	Copy-Item -Recurse "C:\git-sdk-64\etc\pacman.d" -Destination "C:\Program Files\Git\etc"; `
	Copy-Item -Recurse "C:\git-sdk-64\var" -Destination "C:\Program Files\Git" `
}

Invoke-Expression "bash.exe -c -i `"pacman -S --noconfirm pacman`""
choco upgrade choco-cleaner --params "'/NOTASK:TRUE'" -y; Start-Process -FilePath "C:\ProgramData\chocolatey\bin\choco-cleaner.bat" -Wait
choco upgrade curl -y
choco upgrade git -y; git config --global http.sslBackend openssl

choco upgrade 7zip -y
choco upgrade adb -y
choco upgrade agentransack -y
winget install 9NP83LWLPZ9K --silent --accept-package-agreements --accept-source-agreements # apple devices
choco upgrade auto-dark-mode -y
choco upgrade bat -y
choco upgrade bulkrenameutility -y
choco upgrade chrome-remote-desktop-chrome -y
choco upgrade chrome-remote-desktop-host -y
choco upgrade clink-maintained -y; cmd.exe /c "`"C:\Program Files (x86)\clink\clink`" update /S";cmd.exe /c "`"C:\Program Files (x86)\clink\clink`" autorun uninstall"
choco upgrade cutepdf -y
choco upgrade dbeaver -y
choco upgrade instanteyedropper.app -y --ignore-checksums -y
choco upgrade ffmpeg -y
choco upgrade filezilla -y
choco upgrade firefox -y --params "/NoTaskbarShortcut /NoDesktopShortcut"
If ($Outdated -match "ghostscript") { choco uninstall ghostscript -f -y }; choco upgrade ghostscript -y
choco upgrade googlechrome -y --ignore-checksums -y
choco upgrade gimp -y
choco upgrade github-desktop -y
choco upgrade guiformat -y
choco upgrade handbrake -y
choco upgrade hxd -y
winget install 9PKTQ5699M62 --silent --accept-package-agreements --accept-source-agreements # icloud
choco upgrade imagemagick.app -y
choco upgrade imgburn -y
choco upgrade inkscape -y
choco upgrade irfanview -y
choco upgrade irfanviewplugins -y
choco upgrade kitty -y
choco upgrade libreoffice-still -y
choco upgrade linux-reader -y
choco upgrade lsd -y
choco upgrade mp3tag -y
choco upgrade nextdns -y
choco upgrade nerd-fonts-meslo -y;robocopy  C:\Windows\Fonts "$Env:USERPROFILE\Fonts Backup" /XO
choco upgrade nmap -y
choco upgrade notepadplusplus -y
choco upgrade ntop.portable -y
choco upgrade nvm -y; nvm install lts; nvm use lts

# remove old node versions
Set-Location "$Env:PROGRAMDATA\nvm"; $Nodes = Get-ChildItem -Directory | Sort-Object Name; $NodeCount = 0; `
foreach ($Node in $Nodes) { $NodeCount++; If ($NodeCount -lt $Nodes.Length - 1) { nvm uninstall $Node.Name } }; Set-Location -

choco upgrade oh-my-posh -y;oh-my-posh disable notice
choco upgrade onedrive --ignore-checksums -y
choco upgrade paint.net -y
winget install -e --id Poly.PlantronicsHub # plantronics hub
choco upgrade pngquant -y
choco upgrade pngyu -y
choco upgrade powershell-core -y; Install-Module posh-git -Force; Install-Module PSReadLine -AllowPrerelease -Force; Install-Module -Name Terminal-Icons -Repository PSGallery -Force
choco upgrade powertoys -y

# ps-sfta - file type associations
$GitDir = "C:\PS-SFTA"; If (Test-Path $GitDir) { Set-Location $GitDir; git pull; Set-Location - } Else { git clone "https://github.com/DanysysTeam/PS-SFTA.git" $GitDir }

. $GitDir\SFTA.ps1
Set-FTA IrfanView.gif .gif
Set-FTA IrfanView.jpg .jpeg
Set-FTA IrfanView.jpg .jpg
Set-FTA IrfanView.png .png
Set-FTA IrfanView.tif .tif
Set-FTA VLC.mp3 .mp3
Set-FTA VLC.mpeg .mpeg

choco upgrade puretext -y
If ($Outdated -match "python") { choco uninstall python -f -y }; choco upgrade python -y; python -m pip install -U pip
choco upgrade ruby -y
If ($Outdated -match "scribus") { choco uninstall scribus -f -y }; choco upgrade scribus -i -y
choco upgrade sd-card-formatter -y
choco upgrade sharpkeys -y
choco upgrade strawberryperl -y
choco upgrade sumatrapdf -y
choco upgrade tftpd32 -y
choco upgrade vlc -y

# vim
If ($Outdated -match "vim") { choco uninstall vim -f -y }; choco upgrade vim -y --params "'/NoDesktopShortcuts'"
$GitDir = "$Env:USERPROFILE\.vim\pack\Exafunction\start\codeium.vim"; If (Test-Path $GitDir) { Set-Location $GitDir; git pull; Set-Location - } Else { git clone "https://github.com/Exafunction/codeium.vim" $GitDir }
$GitDir = "$Env:USERPROFILE\vimfiles\pack\Exafunction\start\codeium.vim"; If (Test-Path $GitDir) { Set-Location $GitDir; git pull; Set-Location - } Else { git clone "https://github.com/Exafunction/codeium.vim" $GitDir }

choco upgrade vscode -y --params "/NoDesktopIcon"
choco upgrade wireguard -y
choco upgrade wireshark -y
choco upgrade winget -y
choco upgrade winmerge -y
choco upgrade xmlstarlet -y
winget install -e --id yt-dlg.yt-dlg
choco upgrade zoom -y

# zsh
Invoke-Expression "bash.exe -c -i `"pacman -S --needed --noconfirm --overwrite \* zsh`""
$GitDir = "$Env:USERPROFILE\.zsh\zsh-autosuggestions"; If (Test-Path $GitDir) { Set-Location $GitDir; git pull; Set-Location - } Else { git clone "https://github.com/zsh-users/zsh-autosuggestions" $GitDir}
$GitDir = "$Env:USERPROFILE\.zsh\zsh-syntax-highlighting"; If (Test-Path $GitDir) { Set-Location $GitDir; git pull; Set-Location - } Else { git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" $GitDir }
Get-ChildItem $HOME | Where-Object { $_.Name -match '^\.zsh_history\..+' } | Where-Object LastWriteTime -lt  (Get-Date).AddDays(-5) | Remove-Item
