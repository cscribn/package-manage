# bash
curl -sSLo "$Env:USERPROFILE\.bashrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/bash/bashrc-win
curl -sSLo "$Env:USERPROFILE\.inputrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/bash/inputrc-win

# clink
curl -sSLo "$Env:LOCALAPPDATA\clink\oh-my-posh.lua" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/clink/oh-my-posh.lua

# lsd
New-Item -ItemType Directory -Force -Path "$Env:USERPROFILE\.config\lsd"
curl -sSLo "$Env:USERPROFILE\.config\lsd\config.yaml" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/lsd/config.yaml
curl -sSLo "$Env:USERPROFILE\.config\lsd\icons.yaml" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/lsd/icons.yaml

# microsoft-windows-terminal
New-Item -ItemType Directory -Force -Path "$Env:USERPROFILE\.config\microsoft-windows-terminal\ProfileIcons"
curl -sSLo "$Env:USERPROFILE\.config\microsoft-windows-terminal\ProfileIcons\ssh.ico" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/ProfileIcons/ssh.ico
curl -sSLo "$Env:USERPROFILE\.config\microsoft-windows-terminal\ProfileIcons\zsh.ico" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/ProfileIcons/zsh.ico
New-Item -ItemType Directory -Force -Path "$Env:USERPROFILE\.config\microsoft-windows-terminal\Scripts"
curl -sSLo "$Env:USERPROFILE\.config\microsoft-windows-terminal\Scripts\SshWithPassword.ps1" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/Scripts/SshWithPassword.ps1;

# oh-my-posh
$GitDir = "$Env:USERPROFILE\.config\oh-my-posh"; If (Test-Path $GitDir) { Set-Location $GitDir; git pull -q; Set-Location - } Else { git clone -q "https://github.com/cscribn/dotfiles-oh-my-posh.git" $GitDir}

# powershell-core
New-Item -ItemType Directory -Force -Path "$Env:USERPROFILE\.config\powershell"
curl -sSLo "$Env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/powershell-core/Microsoft.PowerShell_profile.ps1
curl -sSLo "$Env:USERPROFILE\Documents\PowerShell\Terminal-Icons.Emoji.ps1" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/powershell-core/Terminal-Icons.Emoji.ps1

# vim
Set-Location "$Env:USERPROFILE"; curl -sSLo ".vimrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/vim/vimrc; Set-Location -

# zsh (sparse checkout of dotfiles-misc: repo root $Env:USERPROFILE\.config, only the zsh directory)
$GitDir = "$Env:USERPROFILE\.config"
If (Test-Path "$GitDir\.git") { git -C $GitDir pull -q } Else {
    Remove-Item -Recurse -Force "$GitDir\zsh" -ErrorAction SilentlyContinue # legacy dotfiles-zsh clone
    git -C $GitDir init -q
    git -C $GitDir remote add origin "https://github.com/cscribn/dotfiles-misc.git"
    git -C $GitDir sparse-checkout set --no-cone '/zsh/'
    git -C $GitDir fetch -q origin
    git -C $GitDir checkout -q -b main --track origin/main
}
Copy-Item -Force -Path "$GitDir\zsh\zshrc-win" -Destination "$Env:USERPROFILE\.zshrc"
