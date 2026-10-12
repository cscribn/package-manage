# dotfiles-misc
Git-CloneOrPull -Url "https://github.com/cscribn/dotfiles-misc.git" -Destination "$Env:USERPROFILE\.config\dotfiles-misc" -Quiet

# bash
Copy-Item -Force -Path "$Env:USERPROFILE\.config\dotfiles-misc\bash\bashrc-win" -Destination "$Env:USERPROFILE\.bashrc"
Copy-Item -Force -Path "$Env:USERPROFILE\.config\dotfiles-misc\bash\inputrc-win" -Destination "$Env:USERPROFILE\.inputrc"

# clink
Copy-Item -Force -Path "$Env:USERPROFILE\.config\dotfiles-misc\clink\oh-my-posh.lua" -Destination "$Env:LOCALAPPDATA\clink\oh-my-posh.lua"

# lsd
Copy-Item -Force -Path "$Env:USERPROFILE\.config\dotfiles-misc\lsd\config.yaml" -Destination "$Env:USERPROFILE\.config\lsd\config.yaml"
Copy-Item -Force -Path "$Env:USERPROFILE\.config\dotfiles-misc\lsd\icons.yaml" -Destination "$Env:USERPROFILE\.config\lsd\icons.yaml"

# microsoft-windows-terminal
New-Item -ItemType Directory -Force -Path "$Env:USERPROFILE\.config\microsoft-windows-terminal\ProfileIcons"
Copy-Item -Force -Path "$Env:USERPROFILE\.config\dotfiles-misc\microsoft-windows-terminal\ProfileIcons\ssh.ico" -Destination "$Env:USERPROFILE\.config\microsoft-windows-terminal\ProfileIcons\ssh.ico"
Copy-Item -Force -Path "$Env:USERPROFILE\.config\dotfiles-misc\microsoft-windows-terminal\ProfileIcons\zsh.ico" -Destination "$Env:USERPROFILE\.config\microsoft-windows-terminal\ProfileIcons\zsh.ico"

New-Item -ItemType Directory -Force -Path "$Env:USERPROFILE\.config\microsoft-windows-terminal\Scripts"
Copy-Item -Force -Path "$Env:USERPROFILE\.config\dotfiles-misc\microsoft-windows-terminal\Scripts\SshWithPassword.ps1" -Destination "$Env:USERPROFILE\.config\microsoft-windows-terminal\Scripts\SshWithPassword.ps1"

# oh-my-posh
Git-CloneOrPull -Url "https://github.com/cscribn/dotfiles-oh-my-posh.git" -Destination "$Env:USERPROFILE\.config\oh-my-posh" -Quiet

# powershell-core
Copy-Item -Force -Path "$Env:USERPROFILE\.config\dotfiles-misc\powershell-core\Microsoft.PowerShell_profile.ps1" -Destination "$Env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
Copy-Item -Force -Path "$Env:USERPROFILE\.config\dotfiles-misc\powershell-core\Terminal-Icons.Emoji.ps1" -Destination "$Env:USERPROFILE\Documents\PowerShell\Terminal-Icons.Emoji.ps1"

# vim
Copy-Item -Force -Path "$Env:USERPROFILE\.config\dotfiles-misc\vim\vimrc" -Destination "$Env:USERPROFILE\.vimrc"

# zsh
Copy-Item -Force -Path "$Env:USERPROFILE\.config\dotfiles-misc\zsh\zshrc-win" -Destination "$Env:USERPROFILE\.zshrc"
