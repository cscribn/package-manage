#!/usr/bin/env bash

# variables
declare clone
declare git_dir
declare git_main
declare git_origin
declare git_url

# bash
curl -Lo "${HOME}/.bashrc" https://raw.githubusercontent.com/cscribn/config-misc/main/bash/bashrc-mac

# bbedit
curl -Lo "${HOME}/Library/Application Support/BBEdit/Language Modules/CSharpLanguageModule.plist" https://luminaryapps.com/code/CSharpLanguageModule.plist
curl -Lo "${HOME}/Library/Application Support/BBEdit/Language Modules/PowerShell.plist" https://raw.githubusercontent.com/doug-baer/BBEdit-PowerShell/master/PowerShell.plist

# oh-my-posh
git_dir="${HOME}/.config/oh-my-posh"
git_url="https://github.com/cscribn/config-oh-my-posh.git"
clone=0

if [[ ! -d "$git_dir" ]]; then
	clone=1
else
	cd "$git_dir" || exit
	git fetch
	git_main=$(git rev-parse main)
	git_origin=$(git rev-parse origin/main)
	cd - || exit

	if [[ "$git_main" != "$git_origin" ]]; then
		rm -rf "$git_dir"
		clone=1
	fi
fi

if [[ "$clone" = 1 ]]; then
	git clone "$git_url" "$git_dir"
fi

# vim
curl -Lo "${HOME}/.vimrc" https://raw.githubusercontent.com/cscribn/config-misc/main/vim/vimrc

# zsh
git_dir="${HOME}/.config/zsh"
git_url="https://github.com/cscribn/config-zsh.git"
clone=0

if [[ ! -d "$git_dir" ]]; then
	clone=1
else
	cd "$git_dir" || exit
	git fetch
	git_main=$(git rev-parse main)
	git_origin=$(git rev-parse origin/main)
	cd - || exit

	if [[ "$git_main" != "$git_origin" ]]; then
		rm -rf "$git_dir"
		clone=1
	fi
fi

if [[ "$clone" = 1 ]]; then
	git clone "$git_url" "$git_dir"
	cp ~/.config/zsh/zshrc-mac ~/.zshrc
fi

# pwsh
mkdir -p "${HOME}/.config/powershell"
curl -Lo "${HOME}/.config/powershell/Microsoft.PowerShell_profile.ps1" https://raw.githubusercontent.com/cscribn/config-misc/main/powershell-core/Microsoft.PowerShell_profile.ps1

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
