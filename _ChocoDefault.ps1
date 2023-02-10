# Non-Chocolatey installations (add/update these first)
# chocolatey itself
# git-sdk (uninstall once pacman is scriptable)
# googledrive
# microsoft-windows-terminal
# tcno account switcher
# winget

# Note: Add or Remove Items in Start menu: https://support.microsoft.com/en-us/topic/removing-invalid-entries-in-the-add-remove-programs-tool-0dae27c1-0b06-2559-311b-635cd532a6d5

# Note: Removing Invalid Entries in the Add/Remove Programs Tool: https://support.microsoft.com/en-us/topic/removing-invalid-entries-in-the-add-remove-programs-tool-0dae27c1-0b06-2559-311b-635cd532a6d5

$Global:StartTime = Get-Date

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
choco upgrade git -y

choco upgrade 7zip -y
choco upgrade agentransack -y
choco upgrade bulkrenameutility -y
choco upgrade chrome-remote-desktop-chrome -y
choco upgrade chrome-remote-desktop-host -y
choco upgrade cutepdf -y

# dotnet-sdk https://github.com/dotnetcore-chocolatey/dotnetcore-chocolateypackages
If ($Outdated -match "dotnet-6.0-sdk") {
	choco uninstall dotnet-6.0-sdk -y
}

If ($Outdated -match "dotnet-7.0-sdk") {
	choco uninstall dotnet-7.0-sdk -y

}

choco upgrade dotnet-6.0-sdk -y
choco upgrade dotnet-7.0-sdk -y

choco upgrade dvddecrypter -y
choco upgrade filezilla -y
choco upgrade firefox --params /NoTaskbarShortcut -y
choco upgrade freefilesync -y
choco upgrade ghostscript -y
choco upgrade googlechrome -y
choco upgrade gimp -y
choco upgrade guiformat -y
choco upgrade handbrake -y
choco upgrade imgburn -y
choco upgrade inkscape -y
choco upgrade irfanview -y
choco upgrade irfanviewplugins -y
choco upgrade jcpicker -y
choco upgrade kitty -y
choco upgrade libreoffice-still -y
choco upgrade lsd -y

# Meslo LGS Nerd Font
Remove-Item "$Env:Windir\Fonts\Meslo LG S Regular Nerd Font Complete Windows Compatible.ttf"
curl -Lo "$Env:Windir\Fonts\Meslo LG S Regular Nerd Font Complete Windows Compatible.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Regular/complete/Meslo%20LG%20S%20Regular%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf

[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts", "MesloLGS NF", "Meslo LG S Regular Nerd Font Complete Windows Compatible.ttf")

robocopy  C:\Windows\Fonts "$Env:USERPROFILE\Fonts Backup" /XO

choco upgrade microsoft-edge -y
choco upgrade mp3tag -y
choco upgrade nextdns -y

# nvm
choco upgrade nvm -y
Update-SessionEnvironment

choco upgrade notepadplusplus -y
choco upgrade onedrive --ignore-checksums -y
choco upgrade oh-my-posh -y
choco upgrade paint.net -y
choco upgrade pngquant -y
choco upgrade pngyu -y

# powershell-core
choco upgrade powershell-core -y
Install-Module posh-git -Force
Install-Module PSReadLine -AllowPrerelease -Force
Install-Module -Name Terminal-Icons -Repository PSGallery

choco upgrade puretext -y
winget uninstall -e --id Python.Python.3.11
choco upgrade python -y
python -m pip install -U pip
choco upgrade quicktime -y

# ruby
If ($Outdated -match "ruby") {
	choco uninstall ruby -y
	choco uninstall ruby.install -y
	choco install ruby -y
}

choco upgrade scribus -y
choco upgrade sharpkeys -y
choco upgrade sqlitebrowser -y

# perl
choco upgrade strawberryperl -y
cpanm -n Perl::LanguageServer

choco upgrade sumatrapdf -y
choco upgrade tftpd32 -y
choco upgrade vlc -y
choco upgrade vim -y
choco upgrade vscode -y
choco upgrade winmerge -y
choco upgrade youtube-dl-gui -y
choco upgrade zoom -y

# zsh
Invoke-Expression "bash.exe -c -i `"pacman -S --noconfirm --overwrite \* zsh`""

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

# node - put here for timing issue
(Get-ChildItem "C:\ProgramData\nvm" | ForEach-Object {$_.FullName}) -match "\\v.*" | Remove-Item -Recurse
nvm install latest
nvm use latest

# Registry

# Google Chrome - remote access Curtain Mode
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome", "RemoteAccessHostRequireCurtain", 1)
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server", "fDenyTSConnections", 0)
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp", "UserAuthentication", 0)
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp", "SecurityLayer", 1)

# Lock Screen - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization", "NoLockScreen", 1)

# Modern Standby - disable
[Microsoft.Win32.Registry]::SetValue
("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power", "PlatformAoAcOverride", 0)

# Start Menu - disable Bing Search
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer", "DisableSearchBoxSuggestions", 1)

# Windows - old right-click
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32", "", "")

. $PSScriptRoot\_ChocoDefaultConfig.ps1
