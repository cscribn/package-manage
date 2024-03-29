#!/usr/bin/env bash

# Non-brew installations (add/update these first)
# embrava
# filezilla
# paste plain text

# settings
set -o nounset
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

# variables
declare script_name
script_name=$(basename "${0}")
declare script_dir
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
declare git_dir
declare git_main
declare git_origin
declare git_url

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ./${script_name}"
	exit
fi

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"

brew update || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# fix, clean, upgrade all brew
brew doctor
brew autoremove
brew cleanup
brew upgrade

brew tap common-fate/granted
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions
brew install git || brew upgrade git

brew install --cask adobe-acrobat-reader || brew upgrade --cask adobe-acrobat-reader
brew install --cask alt-tab || brew upgrade --cask alt-tab
brew install --cask barrier || brew upgrade --cask barrier
brew install bash || brew upgrade bash
brew install --cask bbedit || brew upgrade --cask bbedit
brew install curl || brew upgrade curl
brew install --cask dbeaver-community || brew upgrade --cask dbeaver-community
brew install direnv || brew upgrade direnv
brew install --cask docker || brew upgrade --cask docker
brew install ffmpeg || brew upgrade ffmpeg
brew install --cask firefox || install --cask firefox
brew install --cask gimp || brew upgrade --cask gimp

# git-lfs
brew install git-lfs || brew upgrade git-lfs
git lfs install
sudo git lfs install --system

brew install --cask font-meslo-lg-nerd-font || brew upgrade --cask font-meslo-lg-nerd-font
brew install gifsicle || brew upgrade gifsicle
brew install git || brew upgrade git
brew install --cask github || brew upgrade --cask github
brew install --cask google-drive || brew upgrade --cask google-drive
brew install --cask gpg-suite || brew upgrade --cask gpg-suite
brew install granted || brew upgrade granted
brew install helm || brew upgrade helm
brew install --cask hex-fiend || brew upgrade --cask hex-fiend
brew install htop || brew upgrade htop
brew install --cask iterm2 || brew upgrade --cask iterm2
brew install --cask itsycal ||brew upgrade --cask itsycal
brew install jq ||brew upgrade jq

# psql
brew install libpq || brew upgrade libpq
brew link --force libpq

brew install --cask libreoffice || brew upgrade --cask libreoffice
brew install lsd || brew upgrade lsd
brew install --cask microsoft-edge || brew upgrade --cask microsoft-edge
brew install --cask microsoft-teams || brew upgrade --cask microsoft-teams

# node
brew install nvm || brew upgrade nvm
export NVM_DIR="${HOME}/.nvm"
[[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

nvm install node

# oh-my-posh
brew install jandedobbeleer/oh-my-posh/oh-my-posh || brew upgrade jandedobbeleer/oh-my-posh/oh-my-posh
oh-my-posh disable notice

brew install --cask oracle-jdk17 || brew upgrade --cask oracle-jdk17
brew install perl || brew upgrade perl

# python
python3 -m venv "${HOME}/.venv"
source "${HOME}/.venv/bin/activate"
python3 -m pip install -U pip

brew install --cask pinta || brew upgrade --cask pinta
brew install poetry || brew upgrade poetry
brew install --cask postgres-unofficial || brew upgrade --cask postgres-unofficial
brew install --cask postman || brew upgrade --cask postman
brew install --cask powershell || brew upgrade --cask powershell
brew install pre-commit || brew upgrade pre-commit
brew install --cask rectangle || brew upgrade --cask rectangle

# ruby
brew install rbenv || brew upgrade rbenv
rm -rf "${HOME}/.rbenv/plugins/ruby-build"
git clone https://github.com/rbenv/ruby-build.git "${HOME}/.rbenv/plugins/ruby-build"

brew install --cask the-unarchiver || brew upgrade --cask the-unarchiver
brew install tsh || brew upgrade tsh
brew install --cask visual-studio-code || brew upgrade --cask visual-studio-code

# vim
brew install vim || brew upgrade vim
git_dir="${HOME}/.vim/pack/github/start/copilot.vim"
git_url="https://github.com/github/copilot.vim.git"

if [[ ! -d "$git_dir" ]]; then
	git clone "$git_url" "$git_dir"
else
	cd "$git_dir" || exit
	git pull origin release
	cd - || exit
fi

brew install --cask vlc || brew upgrade --cask vlc
brew install yarn || brew upgrade yarn

# zsh
brew install zsh || brew upgrade zsh

git_dir="${HOME}/.zsh/zsh-autosuggestions"

if [[ -d "$git_dir" ]]; then
	cd "$git_dir" || exit
	git fetch
	git_main=$(git rev-parse master)
	git_origin=$(git rev-parse origin/master)
	cd - || exit

	if [[ "$git_main" != "$git_origin" ]]; then
		rm -rf "$git_dir"
	fi
fi

git_dir="${HOME}/.zsh/zsh-syntax-highlighting"

if [[ -d "$git_dir" ]]; then
	cd "$git_dir" || exit
	git fetch
	git_main=$(git rev-parse master)
	git_origin=$(git rev-parse origin/master)
	cd - || exit

	if [[ "$git_main" != "$git_origin" ]]; then
		rm -rf "$git_dir"
	fi
fi

source "${script_dir}/_brew-work-config.sh"
