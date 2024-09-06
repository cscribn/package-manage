# bash
curl -Lo "$Env:USERPROFILE\.bashrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/bash/bashrc-win

# clink
curl -Lo "$Env:LOCALAPPDATA\clink\oh-my-posh.lua" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/clink/oh-my-posh.lua

# oh-my-posh
$GitDir = "$Env:USERPROFILE\.config\oh-my-posh"; If (Test-Path $GitDir) { Set-Location $GitDir; git pull; Set-Location - } Else { git clone "https://github.com/cscribn/dotfiles-oh-my-posh.git" $GitDir}

# powershell-core
curl -Lo "$Env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/powershell-core/Microsoft.PowerShell_profile.ps1

# vim
Set-Location "$Env:USERPROFILE"; curl -Lo ".vimrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/vim/vimrc; Set-Location -

# zsh
$GitDir = "$Env:USERPROFILE\.config\zsh"; If (Test-Path $GitDir) { Set-Location $GitDir; git pull; Set-Location - } Else { git clone "https://github.com/cscribn/dotfiles-zsh.git" $GitDir}; `
Copy-Item -Force -Path "$GitDir\zshrc-win" -Destination "$Env:USERPROFILE\.zshrc"; `
Copy-Item -Recurse -Force -Path "$GitDir\zsh.ico" -Destination "C:\Program Files\Git\usr\share\icons\locolor\32x32\apps"
