#!/bin/bash

# settings
set -o errexit
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

# global variables
SCRIPT_NAME="$(basename "${0}")"
readonly SCRIPT_NAME
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly SCRIPT_DIR

# oh-my-posh
git_dir="${HOME}/.config/oh-my-posh"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/cscribn/dotfiles-oh-my-posh.git" "$git_dir"; fi

# vim
curl -Lo "${HOME}/.vimrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/vim/vimrc

# zsh
git_dir="${HOME}/.config/zsh"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/cscribn/dotfiles-zsh.git" "$git_dir"; fi; \
cp "${HOME}/.config/zsh/zshrc-pi" "${HOME}/.zshrc"
