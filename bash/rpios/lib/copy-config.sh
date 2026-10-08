#!/bin/bash

# lsd
mkdir -p "${HOME}/.config/lsd"
curl -sSLo "${HOME}/.config/lsd/config.yaml" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/lsd/config.yaml
curl -sSLo "${HOME}/.config/lsd/icons.yaml" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/lsd/icons.yaml

# oh-my-posh
git_dir="${HOME}/.config/oh-my-posh"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/cscribn/dotfiles-oh-my-posh.git" "$git_dir"; fi

# vim
curl -sSLo "${HOME}/.vimrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/vim/vimrc

# zsh (sparse checkout of dotfiles-misc: repo root ~/.config, only the zsh directory)
git_dir="${HOME}/.config"
if [[ -d "$git_dir/.git" ]]; then
    git -C "$git_dir" pull
else
    rm -rf "$git_dir/zsh" # legacy dotfiles-zsh clone
    git -C "$git_dir" init
    git -C "$git_dir" remote add origin "https://github.com/cscribn/dotfiles-misc.git"
    git -C "$git_dir" sparse-checkout set --no-cone '/zsh/'
    git -C "$git_dir" fetch origin
    git -C "$git_dir" checkout -b main --track origin/main
fi
cp "${HOME}/.config/zsh/zshrc-rpios" "${HOME}/.zshrc"
