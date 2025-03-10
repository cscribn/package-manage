#!/bin/bash
# Non-package installations (add these first)
# rust (curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh)

# update, autoremove, clean, upgrade all apt
sudo apt update
sudo apt dist-upgrade -y

# btop
wget -qO "${HOME}/btop.tbz" https://github.com/aristocratos/btop/releases/latest/download/btop-aarch64-linux-musl.tbz; \
sudo tar xf "${HOME}/btop.tbz" -C /usr/local/bin --strip-components=3 ./btop/bin/btop; \
rm -rf "${HOME}/btop.tbz"

sudo apt install curl -y
sudo apt install neofetch -y
sudo apt install fzf -y
sudo apt install git -y
rustup update
sudo apt install htop -y
cargo install lsd

git_dir="${HOME}/motd"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/cscribn/motd" "$git_dir"; fi

# oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm -O /usr/local/bin/oh-my-posh; \
sudo chmod +x /usr/local/bin/oh-my-posh; /usr/local/bin/oh-my-posh disable notice

sudo apt install python3-pip -y
git clone https://github.com/AndrewFromMelbourne/raspi2png; sudo cp -a raspi2png/raspi2png /usr/local/bin; rm -rf ./raspi2png

sudo apt install speedtest-cli -y
sudo apt install unzip -y
sudo apt install vim -y

# zsh
sudo apt install zsh -y

git_dir="${HOME}/.zsh/zsh-autosuggestions"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-autosuggestions" "$git_dir"; fi
git_dir="${HOME}/.zsh/zsh-syntax-highlighting"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$git_dir"; fi

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ); \
source "${script_dir}/_pi-default-config.sh"
