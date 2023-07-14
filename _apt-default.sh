#!/bin/bash
# Non-apt installations (add these first)
# rust (curl https://sh.rustup.rs -sSf | sh)

# variables
declare script_name
script_name=$(basename "${0}")
declare script_dir
script_dir="$(dirname "$0")"
declare git_dir
declare git_main
declare git_origin

sudo apt update
sudo apt install curl -y
sudo apt install git -y
rustup update
cargo install lsd

# oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
/usr/local/bin/oh-my-posh disable notice

sudo apt install python-pip -y
sudo apt install python3-pip -y

# raspi2png
git clone https://github.com/AndrewFromMelbourne/raspi2png
sudo cp -a raspi2png/raspi2png /usr/local/bin
rm -rf ./raspi2png

# ruby
sudo apt install rbenv -y
sudo apt remove ruby-build -y
export PATH="${HOME}/.rbenv/bin:${PATH}"
rm -rf "${HOME}/.rbenv/plugins/ruby-build"

git clone https://github.com/rbenv/ruby-build.git "${HOME}/.rbenv/plugins/ruby-build"

sudo apt install speedtest-cli -y
sudo apt install unzip -y
sudo apt install vim -y

# zsh
sudo apt install zsh -y

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

source "${script_dir}/_apt-default-config.sh"
