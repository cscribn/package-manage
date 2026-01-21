#!/bin/bash

# oh-my-posh
git_dir="${HOME}/.config/oh-my-posh"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/cscribn/dotfiles-oh-my-posh.git" "$git_dir"; fi

# vim
curl -Lo "${HOME}/.vimrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/vim/vimrc

# zsh
git_dir="${HOME}/.config/zsh"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/cscribn/dotfiles-zsh.git" "$git_dir"; fi; \
cp "${HOME}/.config/zsh/zshrc-pi" "${HOME}/.zshrc"
