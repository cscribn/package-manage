#!/bin/bash

# dotfiles-misc
git_clone_or_pull "https://github.com/cscribn/dotfiles-misc.git" "${HOME}/.config/dotfiles-misc" --quiet

# lsd
mkdir -p "${HOME}/.config/lsd"
cp "${HOME}/.config/dotfiles-misc/lsd/config.yaml" "${HOME}/.config/lsd/config.yaml"
cp "${HOME}/.config/dotfiles-misc/lsd/icons.yaml" "${HOME}/.config/lsd/icons.yaml"

# oh-my-posh
git_clone_or_pull "https://github.com/cscribn/dotfiles-oh-my-posh.git" "${HOME}/.config/oh-my-posh" --quiet

# vim
cp "${HOME}/.config/dotfiles-misc/vim/vimrc" "${HOME}/.vimrc"

# zsh
cp "${HOME}/.config/dotfiles-misc/zsh/zshrc-rpios" "${HOME}/.zshrc"
