#!/bin/bash

# bash
curl -Lo "${HOME}/.profile" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/bash/bashrc-anbernic

# oh-my-posh
config_dir="${HOME}/.config/oh-my-posh"; \
repo_url="https://github.com/cscribn/dotfiles-oh-my-posh/archive/refs/heads/main.zip"; \
temp_zip="${HOME}/oh-my-posh.zip"; \
[[ -d "$config_dir" ]] && rm -rf "$config_dir"; \
wget -O "$temp_zip" "$repo_url"; \
unzip -o "$temp_zip" -d "$HOME"; \
mv "${HOME}/dotfiles-oh-my-posh-main" "$config_dir"; \
rm -f "$temp_zip"

# vim
curl -Lo "${HOME}/.vimrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/vim/vimrc
