# Non-Chocolatey installations (add/update these first)
# git-sdk (uninstall once pacman is scriptable)
# googledrive
# microsoft-windows-terminal
# tcno account switcher

# Note: Add or Remove Items in Start menu: https://support.microsoft.com/en-us/topic/removing-invalid-entries-in-the-add-remove-programs-tool-0dae27c1-0b06-2559-311b-635cd532a6d5

# Note: Removing Invalid Entries in the Add/Remove Programs Tool: https://support.microsoft.com/en-us/topic/removing-invalid-entries-in-the-add-remove-programs-tool-0dae27c1-0b06-2559-311b-635cd532a6d5

$StartTime = Get-Date

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

# bash
choco upgrade git -y

curl -Lo "$Env:USERPROFILE\.bashrc" https://raw.githubusercontent.com/cscribn/config-misc/main/bash/bashrc-win

choco upgrade 7zip -y
choco upgrade agentransack -y
choco upgrade bulkrenameutility -y
choco upgrade chrome-remote-desktop-chrome -y
choco upgrade chrome-remote-desktop-host -y
choco upgrade cutepdf -y

# dotnet-sdk
If ($Outdated -match "dotnet-6.0-sdk") {
    choco uninstall dotnet-6.0-sdk -y
    choco install dotnet-6.0-sdk -y
}

choco upgrade dvddecrypter -y
choco upgrade filezilla -y
choco upgrade firefox --params /NoTaskbarShortcut -y
choco upgrade freefilesync -y
choco upgrade ghostscript -y
choco upgrade googlechrome -y
choco upgrade gimp -y
choco upgrade handbrake -y
choco upgrade imgburn -y
choco upgrade inkscape -y
choco upgrade irfanview -y
choco upgrade irfanviewplugins -y
choco upgrade kitty -y
choco upgrade libreoffice-fresh -y

# Meslo LGS Nerd Font
Remove-Item "$Env:Windir\Fonts\Meslo LG S Regular Nerd Font Complete Windows Compatible.ttf"
curl -Lo "$Env:Windir\Fonts\Meslo LG S Regular Nerd Font Complete Windows Compatible.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Regular/complete/Meslo%20LG%20S%20Regular%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf

[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts", "MesloLGS NF", "Meslo LG S Regular Nerd Font Complete Windows Compatible.ttf")

choco upgrade microsoft-edge -y

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"

curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/config-misc/main/microsoft-windows-terminal/LocalState/settings.json

choco upgrade mp3tag -y
choco upgrade nextdns -y

# nvm
If ($Outdated -match "nvm") {
    choco uninstall nvm -y
    choco uninstall nvm.install -y
    choco install nvm -y
    Update-SessionEnvironment
}

choco upgrade notepadplusplus -y
choco upgrade onedrive --ignore-checksums -y

# oh-my-posh
choco upgrade oh-my-posh -y

$GitDir = "$Env:USERPROFILE\.config\oh-my-posh"
$GitUrl = "https://github.com/cscribn/config-oh-my-posh.git"
$Clone = $FALSE

If (-Not (Test-Path -Path $GitDir)) {
    $Clone = $TRUE
} Else {
    Set-Location $GitDir
    git fetch
    $GitMain = git rev-parse main
    $GitOrigin = git rev-parse origin/main
    Set-Location -

    If ($GitMain -ne $GitOrigin) {
        Remove-Item -Recurse -Force $GitDir
        $Clone = $TRUE
    }
}

If ($Clone) {
    git clone $GitUrl $GitDir
}

$Content = Get-Content "$GitDir\themes\powerlevel10k_rainbow_ansi.omp.json"
$Content.replace("`"home_icon`": `"~`",", "`"folder_separator_icon`": `"/`",`r`n            `"home_icon`": `"~`",") | Set-Content "$GitDir\themes\powerlevel10k_rainbow_ansi.omp.json"

choco upgrade paint.net -y

# powershell-core
choco upgrade powershell-core -y
Install-Module posh-git -Force
Install-Module PSReadLine -AllowPrerelease -Force
Install-Module -Name Terminal-Icons -Repository PSGallery

curl -Lo "$Env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" https://raw.githubusercontent.com/cscribn/config-misc/main/powershell-core/Microsoft.PowerShell_profile.ps1

choco upgrade puretext -y

# python
If ($Outdated -match "python3") {
    choco uninstall python python3 -y
    Remove-Item -Recurse "C:\Python3*"
    choco install python -y
    $PythonPath = Resolve-Path "C:\Python3*"
    Rename-Item -Path "$PythonPath\python.exe" -NewName "python3.exe"
    Rename-Item -Path "$PythonPath\pythonw.exe" -NewName "pythonw3.exe"
}

If ($Outdated -match "python2") {
    hoco uninstall python2 -y
    choco install python2 -y
}

choco upgrade quicktime -y

# ruby
If ($Outdated -match "ruby") {
    choco uninstall ruby -y
    choco uninstall ruby.install -y
    choco install ruby -y
}

choco upgrade scribus -y
choco upgrade sharpkeys -y
choco upgrade strawberryperl -y
choco upgrade sumatrapdf -y
choco upgrade tftpd32 -y
choco upgrade vlc -y

# vim
choco upgrade vim -y
Set-Location "$Env:USERPROFILE"

curl -Lo ".vimrc" https://raw.githubusercontent.com/cscribn/config-misc/main/vim/vimrc

Copy-Item ".vimrc" -Destination "_vimrc"
Set-Location -

choco upgrade vscode -y
choco upgrade winmerge -y
choco upgrade youtube-dl-gui -y
choco upgrade zoom -y

# zsh
Invoke-Expression "bash.exe -c -i `"pacman -S --noconfirm --overwrite \* zsh`""

$GitDir = "$Env:USERPROFILE\.config\zsh"
$GitUrl = "https://github.com/cscribn/config-zsh.git"
$Clone = $FALSE

If (-Not (Test-Path -Path $GitDir)) {
    $Clone = $TRUE
} Else {
    Set-Location $GitDir
    git fetch
    $GitMain = git rev-parse main
    $GitOrigin = git rev-parse origin/main
    Set-Location -

    If ($GitMain -ne $GitOrigin) {
        Remove-Item -Recurse -Force $GitDir
        $Clone = $TRUE
    }
}

If ($Clone) {
    git clone $GitUrl $GitDir

    Copy-Item -Force -Path "$GitDir\zshrc-win" -Destination "$Env:USERPROFILE\.zshrc"
    Copy-Item -Recurse -Force -Path "$GitDir\zsh.ico" -Destination "C:\Program Files\Git\usr\share\icons\locolor\32x32\apps"
}

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

# Start Menu - disable Bing Search
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer", "DisableSearchBoxSuggestions", 1)

# Windows - old right-click
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32", "", "")
