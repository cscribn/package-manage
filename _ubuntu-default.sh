#!/bin/bash
# Non-package installations (add these first)

# update, autoremove, clean, upgrade all apt
sudo apt update
sudo apt autoremove -y
sudo apt clean -y
sudo apt dist-upgrade -y

sudo apt install curl -y
sudo apt install neofetch -y
sudo apt install fzf -y
sudo apt install git -y
sudo apt install htop -y

# lsd
curl -s https://api.github.com/repos/lsd-rs/lsd/releases/latest \
	| grep "https://github.com/lsd-rs/lsd/releases/download/.*/lsd-musl_.*_arm64.deb" \
	| cut -d : -f 2,3 | tr -d \" | wget -qi -; \
sudo dpkg -i lsd-musl_*_arm64.deb; rm -f lsd-musl_*_arm64.deb

# oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm -O /usr/local/bin/oh-my-posh; \
sudo chmod +x /usr/local/bin/oh-my-posh; /usr/local/bin/oh-my-posh disable notice

sudo apt install python-pip -y; sudo apt install python3-pip -y

# ruby
sudo apt install rbenv -y; sudo apt remove ruby-build -y; export PATH="${HOME}/.rbenv/bin:${PATH}"; rm -rf "${HOME}/.rbenv/plugins/ruby-build"; \
git clone https://github.com/rbenv/ruby-build.git "${HOME}/.rbenv/plugins/ruby-build"

sudo apt install speedtest-cli -y
sudo apt install unzip -y
sudo apt install vim -y

# zsh
sudo apt install zsh -y

git_dir="${HOME}/.zsh/zsh-autosuggestions"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-autosuggestions" "$git_dir"; fi
git_dir="${HOME}/.zsh/zsh-syntax-highlighting"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git"; fi

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ); \
source "${script_dir}/_ubuntu-default-config.sh"
