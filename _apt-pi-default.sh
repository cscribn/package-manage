#!/bin/bash
# Non-package installations (add these first)
# rust (curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh)

# update, autoremove, clean, upgrade all apt
sudo apt update
sudo apt autoremove -y
sudo apt clean -y
sudo apt dist-upgrade -y

sudo apt install curl -y
sudo apt install fastfetch -y
sudo apt install git -y
rustup update
sudo apt install htop -y
cargo install lsd

git_dir="${HOME}/motd"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/cscribn/motd" "$git_dir"; fi

# oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm -O /usr/local/bin/oh-my-posh; \
sudo chmod +x /usr/local/bin/oh-my-posh; /usr/local/bin/oh-my-posh disable notice

# pwsh
rm -rf "${HOME}/powershell"; mkdir "${HOME}/powershell"; \
curl -s https://api.github.com/repos/PowerShell/PowerShell/releases/latest \
	| grep "https://github.com/PowerShell/PowerShell/releases/download/.*/powershell-.*-linux-arm32.tar.gz" \
	| cut -d : -f 2,3 | tr -d \" | wget -qi -
tar -xvf ./powershell-*-linux-arm32.tar.gz -C "${HOME}/powershell"; rm -f ./powershell-*-linux-arm32.tar.gz; \
"${HOME}/powershell/pwsh" ./PwshLinux.ps1

sudo apt install python-pip -y; sudo apt install python3-pip -y
git clone https://github.com/AndrewFromMelbourne/raspi2png; sudo cp -a raspi2png/raspi2png /usr/local/bin; rm -rf ./raspi2png

# ruby
sudo apt install rbenv -y; sudo apt remove ruby-build -y; export PATH="${HOME}/.rbenv/bin:${PATH}"; rm -rf "${HOME}/.rbenv/plugins/ruby-build"; \
git clone https://github.com/rbenv/ruby-build.git "${HOME}/.rbenv/plugins/ruby-build"

sudo apt install speedtest-cli -y
sudo apt install unzip -y
sudo apt install vim -y

# zsh
sudo apt install zsh -y

git_dir="${HOME}/.zsh/zsh-autosuggestions"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-autosuggestions" "$git_dir"; fi
git_dir="${HOME}/.zsh/zsh-syntax-highlighting"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$git_dir"; fi

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ); \
source "${script_dir}/_apt-pi-default-config.sh"
