#!/bin/bash
# Non-package installations (add these first)

# Use a verified sudo askpass to keep the workflow unattended.
if [[ -n "${SUDO_ASKPASS:-}" ]]; then
    sudo -A -v
fi

# update, autoremove, clean, upgrade all
sudo -A fwupdmgr refresh
sudo -A fwupdmgr update -y --no-reboot-check
apt_run update
apt_run dist-upgrade -y

apt_run install bat -y
apt_run install btop -y
apt_run install curl -y
apt_run install fastfetch -y
sudo snap refresh firefox
apt_run install fzf -y
apt_run install git -y
apt_run install htop -y
apt_run install jq -y
apt_run install lsd -y

# oh-my-posh
sudo wget -nv https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh; /usr/local/bin/oh-my-posh disable notice

apt_run install ripgrep -y
apt_run install samba -y
apt_run install speedtest-cli -y
apt_run install tmux -y
apt_run install unzip -y
apt_run install vim -y
apt_run install wget -y

# zsh
apt_run install zsh -y

git_dir="${HOME}/.zsh/zsh-autosuggestions"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-autosuggestions" "$git_dir"; fi
git_dir="${HOME}/.zsh/zsh-syntax-highlighting"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$git_dir"; fi
