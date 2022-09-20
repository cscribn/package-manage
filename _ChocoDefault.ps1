# Add or Remove Items in Start menu: https://support.microsoft.com/en-us/topic/removing-invalid-entries-in-the-add-remove-programs-tool-0dae27c1-0b06-2559-311b-635cd532a6d5

# Removing Invalid Entries in the Add/Remove Programs Tool: https://support.microsoft.com/en-us/topic/removing-invalid-entries-in-the-add-remove-programs-tool-0dae27c1-0b06-2559-311b-635cd532a6d5

choco upgrade chocolatey -y
choco upgrade curl -y
choco upgrade git -y

choco upgrade agentransack -y
choco upgrade bulkrenameutility -y
choco upgrade chrome-remote-desktop-chrome -y
choco upgrade chrome-remote-desktop-host -y
choco upgrade cutepdf -y
choco upgrade dvddecrypter -y
choco upgrade filezilla -y
choco upgrade firefox -y
choco upgrade freefilesync -y
choco upgrade ghostscript -y
choco upgrade googlechrome -y
choco upgrade googledrive -y
choco upgrade gimp -y
choco upgrade imgburn -y
choco upgrade inkscape -y
choco upgrade irfanview -y
choco upgrade kitty -y

# Meslo LGS Nerd Font
Set-Location "$Env:Windir\Fonts"

curl -Lo "Meslo LG S Regular Nerd Font Complete Windows Compatible.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Regular/complete/Meslo%20LG%20S%20Regular%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "MesloLGS NF" /t REG_SZ /d "Meslo LG S Regular Nerd Font Complete Windows Compatible.ttf" /f

Set-Location -

choco upgrade microsoft-edge -y

# microsoft-windows-terminal
choco upgrade microsoft-windows-terminal -y
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/config-misc/main/microsoft-windows-terminal/LocalState/settings.json

choco upgrade nextdns -y
choco upgrade notepadplusplus -y
choco upgrade onedrive --ignore-checksums -y

# oh-my-posh
choco upgrade oh-my-posh -y
Remove-Item -Recurse -Force "$Env:USERPROFILE\.config\oh-my-posh"
git clone https://github.com/cscribn/config-oh-my-posh.git  "$Env:USERPROFILE\.config\oh-my-posh"

choco upgrade paint.net -y
# manual: papercut mobility print

# powershell
choco upgrade powershell-core -y
Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module PSReadLine -AllowPrerelease -Force

choco upgrade peazip -y
choco upgrade puretext -y

# ruby
choco upgrade ruby -y
Update-SessionEnvironment
ridk install 2 3
gem install colorls
Remove-Item -Recurse -Force "$Env:USERPROFILE\.config\colorls"
curl -Lo "$Env:USERPROFILE\.config\colorls\dark_colors.yaml" --create-dirs https://raw.githubusercontent.com/cscribn/config-misc/main/colorls/dark_colors_ansi.yaml

choco upgrade scribus -y
choco upgrade sharpkeys -y
choco upgrade sumatrapdf -y
choco upgrade vlc -y
choco upgrade vim -y
choco upgrade zoom -y

# zsh
Remove-Item -Recurse -Force "$Env:USERPROFILE\.config\zsh"
git clone https://github.com/cscribn/config-zsh.git  "$Env:USERPROFILE\.config\zsh"
Copy-Item -Recurse -Force -Path "$Env:USERPROFILE\.config\zsh\zsh.pkg\*" -Destination "C:\Program Files\Git"
Copy-Item -Force -Path "$Env:USERPROFILE\.config\zsh\zshrc-win" -Destination "$Env:USERPROFILE\.zshrc"
Remove-Item -Recurse -Force "$Env:USERPROFILE\.zsh\zsh-autocomplete"
Remove-Item -Recurse -Force "$Env:USERPROFILE\.zsh\zsh-autosuggestions"
Remove-Item -Recurse -Force "$Env:USERPROFILE\.zsh\zsh-syntax-highlighting"

# 7-zip at end to help set as default
choco upgrade 7zip -y

# Registry
# Old right-click
New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Name "InprocServer32"

# Disable Bing in Start
New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows" -Name "Explorer"
New-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -PropertyType "DWORD" -Value "1"
