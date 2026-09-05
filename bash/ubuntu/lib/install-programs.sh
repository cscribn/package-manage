#!/bin/bash
# Non-package installations (add these first)

# Use a verified sudo askpass to keep the workflow unattended.
if [[ -n "${SUDO_ASKPASS:-}" ]]; then
    sudo -A -v
fi

# update, autoremove, clean, upgrade all apt-get
sudo -A apt-get update -q
sudo -A apt-get dist-upgrade -y -q

sudo apt-get install bat -y
sudo apt-get install btop -y
sudo apt-get install curl -y
sudo apt-get install fastfetch -y
sudo snap refresh firefox
sudo apt-get install fzf -y
sudo apt-get install git -y
sudo apt-get install htop -y
sudo apt-get install jq -y
sudo apt-get install lsd -y

# oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh; /usr/local/bin/oh-my-posh disable notice

sudo apt-get install ripgrep -y
sudo apt-get install speedtest-cli -y
sudo apt-get install unzip -y
sudo apt-get install vim -y
sudo apt-get install wget -y

# zsh
sudo apt-get install zsh -y

git_dir="${HOME}/.zsh/zsh-autosuggestions"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-autosuggestions" "$git_dir"; fi
git_dir="${HOME}/.zsh/zsh-syntax-highlighting"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$git_dir"; fi
