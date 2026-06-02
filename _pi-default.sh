#!/bin/bash
# Non-package installations (add these first)

# update, autoremove, clean, upgrade all apt
sudo apt update
sudo apt dist-upgrade -y

sudo apt install btop -y
sudo apt install curl -y
sudo apt install fastfetch -y
sudo apt install fzf -y
sudo apt install git -y
sudo apt install htop -y
sudo apt install lsd -y

git_dir="${HOME}/motd"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/cscribn/motd" "$git_dir"; fi

# oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm -O /usr/local/bin/oh-my-posh; \
sudo chmod +x /usr/local/bin/oh-my-posh; /usr/local/bin/oh-my-posh disable notice

git clone https://github.com/AndrewFromMelbourne/raspi2png; sudo cp -a raspi2png/raspi2png /usr/local/bin; rm -rf ./raspi2png
sudo apt install ripgrep -y
sudo apt install speedtest-cli -y
sudo apt install unzip -y
sudo apt install vim -y

# zsh
sudo apt install zsh -y

git_dir="${HOME}/.zsh/zsh-autosuggestions"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-autosuggestions" "$git_dir"; fi
git_dir="${HOME}/.zsh/zsh-syntax-highlighting"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$git_dir"; fi

source "${SCRIPT_DIR}/_pi-default-config.sh"

