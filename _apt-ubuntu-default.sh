#!/bin/bash
# Non-apt installations (add these first)

# variables
declare script_name
script_name=$(basename "${0}")
declare script_dir
script_dir="$(dirname "$0")"
declare git_dir
declare git_url

# helper functions
fetch_remove() {
	local git_dir="$1"
	local branch="$2"
	local git_main
	local git_origin

	if [[ -d "$git_dir" ]]; then
		cd "$git_dir" || exit
		git fetch
		git_main=$(git rev-parse ${branch})
		git_origin=$(git rev-parse origin/${branch})
		cd - || exit

		if [[ "$git_main" != "$git_origin" ]]; then
			rm -rf "$git_dir"
		fi
	fi
}

# update, autoremove, clean, upgrade all apt
sudo apt update
sudo apt autoremove -y
sudo apt clean -y
sudo apt dist-upgrade -y

sudo apt install curl -y
sudo apt install git -y
sudo apt install htop -y

# lsd
curl -s https://api.github.com/repos/lsd-rs/lsd/releases/latest \
	| grep "https://github.com/lsd-rs/lsd/releases/download/.*/lsd-musl_.*_arm64.deb" \
	| cut -d : -f 2,3 | tr -d \" | wget -qi -
sudo dpkg -i lsd-musl_*_arm64.deb
rm -f lsd-musl_*_arm64.deb

# oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
/usr/local/bin/oh-my-posh disable notice

sudo apt install python-pip -y
sudo apt install python3-pip -y

# ruby
sudo apt install rbenv -y
sudo apt remove ruby-build -y
export PATH="${HOME}/.rbenv/bin:${PATH}"
rm -rf "${HOME}/.rbenv/plugins/ruby-build"

git clone https://github.com/rbenv/ruby-build.git "${HOME}/.rbenv/plugins/ruby-build"

sudo apt install speedtest-cli -y
sudo apt install unzip -y

# vim
sudo apt install vim -y
git_dir="${HOME}/.vim/pack/Exafunction/start/codeium.vim"
git_url="https://github.com/Exafunction/codeium.vim"

if [[ ! -d "$git_dir" ]]; then
	git clone "$git_url" "$git_dir"
else
	cd "$git_dir" || exit
	git pull origin main
	cd - || exit
fi

# zsh
sudo apt install zsh -y
fetch_remove "${HOME}/.zsh/zsh-autosuggestions" "master"
fetch_remove "${HOME}/.zsh/zsh-syntax-highlighting" "master"

source "${script_dir}/_apt-ubuntu-default-config.sh"
