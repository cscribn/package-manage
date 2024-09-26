#!/usr/bin/env bash

# Non-package installations (add/update these first)
# embrava
# filezilla
# google chrome
# sudo git lfs install --system
# paste plain text

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"

brew update || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# fix, clean, upgrade all brew
brew doctor
brew autoremove
brew cleanup
brew upgrade

brew tap common-fate/granted
brew tap snyk/tap
brew install libgit2@1.7 || brew upgrade libgit2@1.7
brew install git || brew upgrade git

brew install --cask adobe-acrobat-reader || brew upgrade --cask adobe-acrobat-reader
brew install --cask alt-tab || brew upgrade --cask alt-tab
brew install --cask barrier || brew upgrade --cask barrier
brew install bash || brew upgrade bash
brew install bat || brew upgrade bat
brew install --cask bbedit || brew upgrade --cask bbedit
brew install curl || brew upgrade curl
brew install --cask dbeaver-community || brew upgrade --cask dbeaver-community
brew install direnv || brew upgrade direnv
brew install --cask docker || brew upgrade --cask docker
brew install fastfetch || brew upgrade fastfetch
brew install ffmpeg || brew upgrade ffmpeg
brew install --cask firefox || install --cask firefox
brew install fzf || brew upgrade fzf
brew install --cask gimp || brew upgrade --cask gimp
brew install git-lfs || brew upgrade git-lfs; git lfs install
brew install --cask font-meslo-lg-nerd-font || brew upgrade --cask font-meslo-lg-nerd-font
brew install gifsicle || brew upgrade gifsicle
brew install git || brew upgrade git
brew install --cask github || brew upgrade --cask github
brew install --cask google-chrome@beta || brew upgrade --cask google-chrome@beta
brew install --cask google-drive || brew upgrade --cask google-drive
brew install --cask gpg-suite || brew upgrade --cask gpg-suite
brew install granted || brew upgrade granted
brew install helm || brew upgrade helm
brew install --cask hex-fiend || brew upgrade --cask hex-fiend
brew install htop || brew upgrade htop
brew install --cask iterm2 || brew upgrade --cask iterm2
brew install --cask itsycal ||brew upgrade --cask itsycal
brew install jq ||brew upgrade jq
brew install libpq || brew upgrade libpq;brew link --force libpq
brew install --cask libreoffice-still || brew upgrade --cask libreoffice-still
brew install lsd || brew upgrade lsd
brew install --cask microsoft-edge # Don't upgrade
brew install --cask microsoft-auto-update || brew upgrade --cask microsoft-auto-update
brew install nmap || brew upgrade nmap

# node
brew install nvm || brew upgrade nvm; export NVM_DIR="${HOME}/.nvm"; \
[[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && \. "/opt/homebrew/opt/nvm/nvm.sh"; \
[[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"; \
nvm install --lts; nvm use --lts;

# remove old node versions
cd "${HOME}/.nvm/versions/node" || exit; \
\ls -dr * | tail -n +2 | xargs -I '{}' bash -c "export NVM_DIR=$HOME/.nvm; [ -s $NVM_DIR/nvm.sh ] && \. $NVM_DIR/nvm.sh; nvm deactivate {} && nvm uninstall {}"; \
cd - || exit

brew install jandedobbeleer/oh-my-posh/oh-my-posh || brew upgrade jandedobbeleer/oh-my-posh/oh-my-posh; oh-my-posh disable notice
brew install --cask oracle-jdk@17 || brew upgrade --cask oracle-jdk@17
brew install perl || brew upgrade perl
brew install --cask pgadmin4 || brew upgrade --cask pgadmin4
brew install --cask pinta || brew upgrade --cask pinta
brew install poetry || brew upgrade poetry
brew install --cask postgres-unofficial || brew upgrade --cask postgres-unofficial
brew install --cask postman || brew upgrade --cask postman
brew install --cask powershell || brew upgrade --cask powershell
brew install pre-commit || brew upgrade pre-commit
brew install --cask rectangle || brew upgrade --cask rectangle
brew install snyk || brew upgrade snyk
brew install --cask the-unarchiver || brew upgrade --cask the-unarchiver
brew install tsh || brew upgrade tsh
brew install --cask visual-studio-code || brew upgrade --cask visual-studio-code
brew install vim || brew upgrade vim
brew install --cask vlc || brew upgrade --cask vlc
brew install --cask wireshark || brew upgrade --cask wireshark
brew install yarn || brew upgrade yarn

# zsh
brew install zsh || brew upgrade zsh

git_dir="${HOME}/.zsh/zsh-autosuggestions"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-autosuggestions" "$git_dir"; fi
git_dir="${HOME}/.zsh/zsh-syntax-highlighting"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git"; fi

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ); \
source "${script_dir}/_mac-work-config.sh"
