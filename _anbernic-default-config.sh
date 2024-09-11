#!/bin/bash

# bash
curl -Lo "${HOME}/.bashrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/bash/bashrc-anbernic

# oh-my-posh
config_dir="${HOME}/.config/oh-my-posh"; \
repo_url="https://github.com/cscribn/dotfiles-oh-my-posh/archive/refs/heads/main.zip"; \
temp_zip="/tmp/oh-my-posh.zip"; \
[[ -d "$config_dir" ]] && rm -rf "${config_dir:?}"/*; \
mkdir -p "$config_dir"; \
wget -O "$temp_zip" "$repo_url"; \
unzip -o "$temp_zip" -d /tmp/; \
mv /tmp/dotfiles-oh-my-posh-main/*; \
rm -rf /tmp/dotfiles-oh-my-posh-main/ "$temp_zip"

# vim
curl -Lo "${HOME}/.vimrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/vim/vimrc
