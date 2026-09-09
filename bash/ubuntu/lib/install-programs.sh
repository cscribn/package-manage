#!/bin/bash
# Non-package installations (add these first)

# Use a verified sudo askpass to keep the workflow unattended.
if [[ -n "${SUDO_ASKPASS:-}" ]]; then
    sudo -A -v
fi

# update, autoremove, clean, upgrade all
sudo -A fwupdmgr refresh
sudo -A fwupdmgr update -y --no-reboot-check
sudo -A apt-get update -q
sudo -A apt-get dist-upgrade -y -q

sudo apt-get install bat -y -q
sudo apt-get install btop -y -q
sudo apt-get install curl -y -q
sudo apt-get install fastfetch -y -q
sudo snap refresh firefox
sudo apt-get install fzf -y -q
sudo apt-get install git -y -q
sudo apt-get install htop -y -q
sudo apt-get install jq -y -q
sudo apt-get install lsd -y -q

# oh-my-posh
sudo wget -nv https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh; /usr/local/bin/oh-my-posh disable notice

sudo apt-get install ripgrep -y -q
sudo apt-get install speedtest-cli -y -q
sudo apt-get install unzip -y -q
sudo apt-get install vim -y -q
sudo apt-get install wget -y -q

# zsh
sudo apt-get install zsh -y -q

git_dir="${HOME}/.zsh/zsh-autosuggestions"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-autosuggestions" "$git_dir"; fi
git_dir="${HOME}/.zsh/zsh-syntax-highlighting"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$git_dir"; fi
