#!/bin/bash

# variables
declare clone

# helper functions
fetch_clone() {
	local git_dir="$1"
	local git_url="$2"
	local branch="$3"
	local git_main
	local git_origin
	clone=0

	if [[ ! -d "$git_dir" ]]; then
		clone=1
	else
		cd "$git_dir" || exit
		git fetch
		git_main=$(git rev-parse $branch)
		git_origin=$(git rev-parse origin/$branch)
		cd - || exit

		if [[ "$git_main" != "$git_origin" ]]; then
			rm -rf "$git_dir"
			clone=1
		fi
	fi

	if [[ "$clone" = 1 ]]; then
		git clone "$git_url" "$git_dir"
	fi
}

# oh-my-posh
fetch_clone "${HOME}/.config/oh-my-posh" "https://github.com/cscribn/config-oh-my-posh.git" "main"

# pwsh
mkdir -p "${HOME}/.config/powershell"
curl -Lo "${HOME}/.config/powershell/Microsoft.PowerShell_profile.ps1" https://raw.githubusercontent.com/cscribn/config-misc/main/powershell-core/Microsoft.PowerShell_profile.ps1

# vim
curl -Lo "${HOME}/.vimrc" https://raw.githubusercontent.com/cscribn/config-misc/main/vim/vimrc

# zsh
fetch_clone "${HOME}/.config/zsh" "https://github.com/cscribn/config-zsh.git" "main"
[[ "$clone" = 1 ]] && cp "${HOME}/.config/zsh/zshrc-rpi" "${HOME}/.zshrc"
