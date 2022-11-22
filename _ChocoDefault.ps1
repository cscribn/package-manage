# Add or Remove Items in Start menu: https://support.microsoft.com/en-us/topic/removing-invalid-entries-in-the-add-remove-programs-tool-0dae27c1-0b06-2559-311b-635cd532a6d5

# Removing Invalid Entries in the Add/Remove Programs Tool: https://support.microsoft.com/en-us/topic/removing-invalid-entries-in-the-add-remove-programs-tool-0dae27c1-0b06-2559-311b-635cd532a6d5

choco upgrade chocolatey -y
choco upgrade curl -y
choco upgrade git -y

choco upgrade 7zip -y
choco upgrade agentransack -y
choco upgrade bulkrenameutility -y
choco upgrade chrome-remote-desktop-chrome -y
choco upgrade chrome-remote-desktop-host -y
choco upgrade cutepdf -y

# dotnet-sdk
choco uninstall dotnet-6.0-sdk -y
choco install dotnet-6.0-sdk -y

choco upgrade dvddecrypter -y
choco upgrade filezilla -y
choco upgrade firefox -y
choco upgrade freefilesync -y
choco upgrade ghostscript -y
choco upgrade googlechrome -y
choco upgrade googledrive -y
choco upgrade gimp -y
choco upgrade handbrake -y
choco upgrade imgburn -y
choco upgrade inkscape -y
choco upgrade irfanview -y
choco upgrade irfanviewplugins -y
choco upgrade kitty -y
choco upgrade libreoffice-fresh -y

# Meslo LGS Nerd Font
curl -Lo "$Env:Windir\Fonts\Meslo LG S Regular Nerd Font Complete Windows Compatible.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Regular/complete/Meslo%20LG%20S%20Regular%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf

[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts", "MesloLGS NF", "Meslo LG S Regular Nerd Font Complete Windows Compatible.ttf")

choco upgrade microsoft-edge -y

# microsoft-windows-terminal
choco upgrade microsoft-windows-terminal -y
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"

curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/config-misc/main/microsoft-windows-terminal/LocalState/settings.json

choco upgrade mp3tag -y
choco upgrade nextdns -y

# node
choco upgrade nvm -y
nvm uninstall latest
nvm install latest
nvm use latest

choco upgrade notepadplusplus -y
choco upgrade onedrive --ignore-checksums -y

# oh-my-posh
choco upgrade oh-my-posh -y

Set-Location "$Env:USERPROFILE\.config\oh-my-posh"
$GitMain = git rev-parse main
$GitHead = git rev-parse HEAD
Set-Location -

if ($GitMain -ne $GitHead)
{
    Remove-Item -Recurse -Force "$Env:USERPROFILE\.config\oh-my-posh"

    git clone https://github.com/cscribn/config-oh-my-posh.git  "$Env:USERPROFILE\.config\oh-my-posh"
}

choco upgrade paint.net -y
choco upgrade partitionwizard -y
choco upgrade peazip -y

# powershell-core
choco upgrade powershell-core -y
Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module posh-git -Force
Install-Module PSReadLine -AllowPrerelease -Force

curl -Lo "$Env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" https://raw.githubusercontent.com/cscribn/config-misc/main/powershell-core/Microsoft.PowerShell_profile.ps1

choco upgrade puretext -y

# python
choco uninstall python -y
choco install python -y
$PythonPath = Resolve-Path "C:\Python3*\python.exe"
$PythonWPath = Resolve-Path "C:\Python3*\pythonw.exe"
Rename-Item -Path "$PythonPath" -NewName "python3.exe"
Rename-Item -Path "$PythonWPath" -NewName "pythonw3.exe"
choco upgrade python2 -y

choco upgrade quicktime -y
choco upgrade reflect-free -y

# ruby
choco uninstall ruby.install -y
choco uninstall ruby -y
choco install ruby -y
Update-SessionEnvironment
ridk install 2 3

choco upgrade scribus -y
choco upgrade sharpkeys -y
choco upgrade strawberryperl -y
choco upgrade sumatrapdf -y
# tcno account switcher
choco upgrade tftpd32 -y
choco upgrade vlc -y

# vim
choco upgrade vim -y
Set-Location "$Env:USERPROFILE"

curl -Lo ".vimrc" https://raw.githubusercontent.com/cscribn/config-misc/main/vim/vimrc

Copy-Item ".vimrc" -Destination "_vimrc"
Set-Location -

choco upgrade winmerge -y
choco upgrade youtube-dl-gui -y
choco upgrade zoom -y

# zsh
Set-Location "$Env:USERPROFILE\.config\zsh"
$GitMain = git rev-parse main
$GitHead = git rev-parse HEAD
Set-Location -

if ($GitMain -ne $GitHead)
{
    Remove-Item -Recurse -Force "$Env:USERPROFILE\.config\zsh"

    git clone https://github.com/cscribn/config-zsh.git  "$Env:USERPROFILE\.config\zsh"

    Copy-Item -Recurse -Force -Path "$Env:USERPROFILE\.config\zsh\zsh.pkg\*" -Destination "C:\Program Files\Git"
    Copy-Item -Force -Path "$Env:USERPROFILE\.config\zsh\zshrc-win" -Destination "$Env:USERPROFILE\.zshrc"
    Remove-Item -Recurse -Force "$Env:USERPROFILE\.zsh\zsh-autocomplete"
    Remove-Item -Recurse -Force "$Env:USERPROFILE\.zsh\zsh-autosuggestions"
    Remove-Item -Recurse -Force "$Env:USERPROFILE\.zsh\zsh-syntax-highlighting"
}

# Registry

# Google Chrome - remote access Curtain Mode
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome", "RemoteAccessHostRequireCurtain", 1)
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server", "fDenyTSConnections", 0)
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp", "UserAuthentication", 0)
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp", "SecurityLayer", 1)

# Lock Screen - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization", "NoLockScreen", 1)

# Start Menu - disable Bing Search
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer", "DisableSearchBoxSuggestions", 1)

# Windows - old right-click
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32", "", "")
