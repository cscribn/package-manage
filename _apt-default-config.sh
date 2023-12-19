#!/bin/bash

# variables
declare clone
declare git_dir
declare git_main
declare git_origin
declare git_url

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

	cp "${HOME}/.config/zsh/zshrc-rpi" "${HOME}/.zshrc"
fi
