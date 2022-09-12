choco upgrade chocolatey -y
choco upgrade curl -y
choco upgrade git -y
choco upgrade git.install -y

choco upgrade 7zip -y
choco upgrade 7zip.install -y
choco upgrade agentransack -y
choco upgrade bulkrenameutility -y
choco upgrade chrome-remote-desktop-chrome -y
choco upgrade chrome-remote-desktop-host -y
choco upgrade cutepdf -y
choco upgrade dvddecrypter -y
choco upgrade filezilla -y
choco upgrade firefox -y
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

curl -fLo "Meslo LG S Regular Nerd Font Complete Windows Compatible.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Regular/complete/Meslo%20LG%20S%20Regular%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "MesloLGS NF" /t REG_SZ /d "Meslo LG S Regular Nerd Font Complete Windows Compatible.ttf" /f

Set-Location -

choco upgrade microsoft-edge -y
choco upgrade microsoft-windows-terminal -y
choco upgrade nextdns -y
choco upgrade notepadplusplus -y
choco upgrade notepadplusplus.install -y
choco upgrade onedrive --ignore-checksums -y
choco upgrade oh-my-posh -y
choco upgrade paint.net -y

# powershell
choco upgrade powershell-core -y
Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module PSReadLine -AllowPrerelease -Force

choco upgrade peazip -y
choco upgrade peazip.install -y
choco upgrade puretext -y
choco upgrade scribus -y
choco upgrade sumatrapdf -y
choco upgrade sumatrapdf.install -y
choco upgrade vlc -y
choco upgrade vlc.install -y
choco upgrade vim -y
choco upgrade zoom -y

# zsh
Remove-Item -Recurse -Force "$Env:USERPROFILE\.config\zsh"
git clone https://github.com/cscribn/config-zsh.git  "$Env:USERPROFILE\.config\zsh"
Copy-Item -Force -Path "$Env:USERPROFILE\.config\zsh\zshrc-win" -Destination "$Env:USERPROFILE\.zshrc"
Copy-Item -Recurse -Force -Path "$Env:USERPROFILE\.config\zsh\zsh.pkg\*" -Destination "C\Program Files\Git"
Remove-Item -Recurse -Force "$Env:USERPROFILE\.config\oh-my-posh"
Remove-Item -Recurse -Force "$Env:USERPROFILE\.config\colorls"
Remove-Item -Recurse -Force "$Env:USERPROFILE\.zsh\zsh-autocomplete"
Remove-Item -Recurse -Force "$Env:USERPROFILE\.zsh\zsh-autosuggestions"
Remove-Item -Recurse -Force "$Env:USERPROFILE\.zsh\zsh-syntax-highlighting"

# microsoft-windows-terminal
Remove-Item -Recurse -Force "$Env:USERPROFILE\.config\microsoft-windows-terminal"
git clone https://github.com/cscribn/config-microsoft-windows-terminal.git  "$Env:USERPROFILE\.config\microsoft-windows-terminal"
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"
Copy-Item -Force -Path "$Env:USERPROFILE\.config\microsoft-windows-terminal\LocalState\settings.json" -Destination "$LocalStateDir"
