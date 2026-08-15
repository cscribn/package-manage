# bash
curl -sSLo "$Env:USERPROFILE\.bashrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/bash/bashrc-win

# clink
curl -sSLo "$Env:LOCALAPPDATA\clink\oh-my-posh.lua" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/clink/oh-my-posh.lua

# microsoft-windows-terminal
New-Item -ItemType Directory -Force -Path "$Env:USERPROFILE\.config\microsoft-windows-terminal\ProfileIcons"
curl -sSLo "$Env:USERPROFILE\.config\microsoft-windows-terminal\ProfileIcons\ssh.ico" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/ProfileIcons/ssh.ico
curl -sSLo "$Env:USERPROFILE\.config\microsoft-windows-terminal\ProfileIcons\zsh.ico" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/ProfileIcons/zsh.ico
New-Item -ItemType Directory -Force -Path "$Env:USERPROFILE\.config\microsoft-windows-terminal\Scripts"
curl -sSLo "$Env:USERPROFILE\.config\microsoft-windows-terminal\Scripts\SshWithPassword.ps1" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/Scripts/SshWithPassword.ps1;

# oh-my-posh
$GitDir = "$Env:USERPROFILE\.config\oh-my-posh"; If (Test-Path $GitDir) { Set-Location $GitDir; git pull; Set-Location - } Else { git clone "https://github.com/cscribn/dotfiles-oh-my-posh.git" $GitDir}

# powershell-core
curl -sSLo "$Env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/powershell-core/Microsoft.PowerShell_profile.ps1

# vim
Set-Location "$Env:USERPROFILE"; curl -sSLo ".vimrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/vim/vimrc; Set-Location -

# zsh
$GitDir = "$Env:USERPROFILE\.config\zsh"; If (Test-Path $GitDir) { Set-Location $GitDir; git pull; Set-Location - } Else { git clone "https://github.com/cscribn/dotfiles-zsh.git" $GitDir}
Copy-Item -Force -Path "$GitDir\zshrc-win" -Destination "$Env:USERPROFILE\.zshrc"
