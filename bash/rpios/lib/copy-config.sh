#!/bin/bash

# lsd
mkdir -p "${HOME}/.config/lsd"
curl -sSLo "${HOME}/.config/lsd/config.yaml" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/lsd/config.yaml
curl -sSLo "${HOME}/.config/lsd/icons.yaml" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/lsd/icons.yaml

# oh-my-posh
git_dir="${HOME}/.config/oh-my-posh"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/cscribn/dotfiles-oh-my-posh.git" "$git_dir"; fi

# vim
curl -sSLo "${HOME}/.vimrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/vim/vimrc

# zsh
git_dir="${HOME}/.config/zsh"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/cscribn/dotfiles-zsh.git" "$git_dir"; fi
cp "${HOME}/.config/zsh/zshrc-rpios" "${HOME}/.zshrc"
