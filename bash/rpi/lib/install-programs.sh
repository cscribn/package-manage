#!/bin/bash
# Non-package installations (add these first)

# update, autoremove, clean, upgrade all apt-get
sudo apt-get update
sudo apt-get dist-upgrade -y

sudo apt-get install btop -y
sudo apt-get install curl -y
sudo apt-get install fastfetch -y
sudo apt-get install fzf -y
sudo apt-get install git -y
sudo apt-get install htop -y
sudo apt-get install lsd -y

git_dir="${HOME}/motd"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/cscribn/motd" "$git_dir"; fi

# oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm -O /usr/local/bin/oh-my-posh; \
sudo chmod +x /usr/local/bin/oh-my-posh; /usr/local/bin/oh-my-posh disable notice

git clone https://github.com/AndrewFromMelbourne/raspi2png; sudo cp -a raspi2png/raspi2png /usr/local/bin; rm -rf ./raspi2png
sudo apt-get install ripgrep -y
sudo apt-get install speedtest-cli -y
sudo apt-get install unzip -y
sudo apt-get install vim -y

# zsh
sudo apt-get install zsh -y

git_dir="${HOME}/.zsh/zsh-autosuggestions"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-autosuggestions" "$git_dir"; fi
git_dir="${HOME}/.zsh/zsh-syntax-highlighting"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$git_dir"; fi
