#!/opt/homebrew/bin/bash

# dotfiles-misc
git_clone_or_pull "https://github.com/cscribn/dotfiles-misc.git" "${HOME}/.config/dotfiles-misc" --quiet

# bash
cp "${HOME}/.config/dotfiles-misc/bash/bashrc-mac" "${HOME}/.bashrc"
cp "${HOME}/.config/dotfiles-misc/bash/inputrc-mac" "${HOME}/.inputrc"

# bbedit
curl -sSLo "${HOME}/Library/Application Support/BBEdit/Language Modules/CSharpLanguageModule.plist" https://luminaryapps.com/code/CSharpLanguageModule.plist
curl -sSLo "${HOME}/Library/Application Support/BBEdit/Language Modules/PowerShell.plist" https://raw.githubusercontent.com/doug-baer/BBEdit-PowerShell/master/PowerShell.plist
defaults write com.barebones.bbedit ZoomWindowsInPlace -bool NO

# finder - show all files (launchctl restarts Finder without the TCC popup from killall)
defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
finder_service="gui/$(id -u)/com.apple.Finder"
if launchctl print "$finder_service" &>/dev/null; then
    launchctl kickstart -k "$finder_service"
fi

# hammerspoon
cp "${HOME}/.config/dotfiles-misc/hammerspoon/init.lua" "${HOME}/.hammerspoon/init.lua"

# lsd
mkdir -p "${HOME}/.config/lsd"
cp "${HOME}/.config/dotfiles-misc/lsd/config.yaml" "${HOME}/.config/lsd/config.yaml"
cp "${HOME}/.config/dotfiles-misc/lsd/icons.yaml" "${HOME}/.config/lsd/icons.yaml"

# oh-my-posh
git_clone_or_pull "https://github.com/cscribn/dotfiles-oh-my-posh.git" "${HOME}/.config/oh-my-posh" --quiet

# vim
cp "${HOME}/.config/dotfiles-misc/vim/vimrc" "${HOME}/.vimrc"

# zsh
cp "${HOME}/.config/dotfiles-misc/zsh/zshrc-mac" "${HOME}/.zshrc"

# pwsh
mkdir -p "${HOME}/.config/powershell"
cp "${HOME}/.config/dotfiles-misc/powershell-core/Microsoft.PowerShell_profile.ps1" "${HOME}/.config/powershell/Microsoft.PowerShell_profile.ps1"
cp "${HOME}/.config/dotfiles-misc/powershell-core/Terminal-Icons.Emoji.ps1" "${HOME}/.config/powershell/Terminal-Icons.Emoji.ps1"

# key bindings
mkdir -p "${HOME}/Library/KeyBindings"

echo '{
/* Remap Home / End keys to be correct */
"\UF729" = "moveToBeginningOfLine:"; /* Home */
"\UF72B" = "moveToEndOfLine:"; /* End */
"$\UF729" = "moveToBeginningOfLineAndModifySelection:"; /* Shift + Home */
"$\UF72B" = "moveToEndOfLineAndModifySelection:"; /* Shift + End */
"^\UF729" = "moveToBeginningOfDocument:"; /* Ctrl + Home */
"^\UF72B" = "moveToEndOfDocument:"; /* Ctrl + End */
"$^\UF729" = "moveToBeginningOfDocumentAndModifySelection:"; /* Shift + Ctrl + Home */
"$^\UF72B" = "moveToEndOfDocumentAndModifySelection:"; /* Shift + Ctrl + End */
}' > "${HOME}/Library/KeyBindings/DefaultKeyBinding.dict"
