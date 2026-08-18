#!/opt/homebrew/bin/bash

# bash
curl -sSLo "${HOME}/.bashrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/bash/bashrc-mac

# bbedit
curl -sSLo "${HOME}/Library/Application Support/BBEdit/Language Modules/CSharpLanguageModule.plist" https://luminaryapps.com/code/CSharpLanguageModule.plist; \
curl -sSLo "${HOME}/Library/Application Support/BBEdit/Language Modules/PowerShell.plist" https://raw.githubusercontent.com/doug-baer/BBEdit-PowerShell/master/PowerShell.plist
defaults write com.barebones.bbedit ZoomWindowsInPlace -bool NO

# finder - show all files (launchctl restarts Finder without the TCC popup from killall)
defaults write com.apple.finder "AppleShowAllFiles" -bool "true" && \
launchctl kickstart -k "gui/$(id -u)/com.apple.finder"

# hammerspoon
curl -sSLo "${HOME}/.hammerspoon/init.lua" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/hammerspoon/init.lua

# oh-my-posh
git_dir="${HOME}/.config/oh-my-posh"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull -q; cd -; else git clone "https://github.com/cscribn/dotfiles-oh-my-posh.git" "$git_dir"; fi

# vim
curl -sSLo "${HOME}/.vimrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/vim/vimrc

# zsh
git_dir="${HOME}/.config/zsh"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull -q; cd -; else git clone "https://github.com/cscribn/dotfiles-zsh.git" "$git_dir"; fi; \
cp "${HOME}/.config/zsh/zshrc-mac" "${HOME}/.zshrc"

# pwsh
mkdir -p "${HOME}/.config/powershell"; \
curl -sSLo "${HOME}/.config/powershell/Microsoft.PowerShell_profile.ps1" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/powershell-core/Microsoft.PowerShell_profile.ps1

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
