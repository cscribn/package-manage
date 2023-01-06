#!/bin/bash
# Non-apt installations (add these first)
# rust (curl https://sh.rustup.rs -sSf | sh)

# variables
declare clone
declare git_dir
declare git_main
declare git_origin
declare git_url

sudo apt update
sudo apt install curl -y
sudo apt install git -y
rustup update

cargo install lsd
wget -O - https://raw.githubusercontent.com/pjgpetecodes/dotnet7pi/main/install.sh | sudo bash

# node
rm -rf "${HOME}/.nvm/versions/node"/*

curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
export NVM_DIR="${HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install node

# oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

git_dir="${HOME}/.config/oh-my-posh"
git_url="https://github.com/cscribn/config-oh-my-posh.git"
clone=0

if [[ ! -d "$git_dir" ]]; then
    clone=1
else
    cd "$git_dir" || exit
    git fetch
    git_main=$(git rev-parse main)
    git_origin=$(git rev-parse origin/main)
    cd - || exit

    if [[ "$git_main" != "$git_origin" ]]; then
        rm -rf "$git_dir"
        clone=1
    fi
fi

if [[ "$clone" = 1 ]]; then
    git clone "$git_url" "$git_dir"
fi

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

eval "$(rbenv init -)"
declare ruby_installed
ruby_installed=$(head -n 1 ${HOME}/.rbenv/version | tr -d '[[:space:]]')
declare ruby_latest
ruby_latest=$(rbenv install --list-all | grep -v - | tail -1 | tr -d '[[:space:]]')

if [[ "$ruby_installed" != "$ruby_latest" ]]; then
    rbenv uninstall -f "$ruby_installed"
    rbenv install --verbose "$ruby_latest"
    rbenv global "$ruby_latest"
fi

sudo apt install unzip -y

# vim
sudo apt install vim -y

curl -Lo "${HOME}/.vimrc" https://raw.githubusercontent.com/cscribn/config-misc/main/vim/vimrc

# zsh
sudo apt install zsh -y

git_dir="${HOME}/.config/zsh"
git_url="https://github.com/cscribn/config-zsh.git"
clone=0

if [[ ! -d "$git_dir" ]]; then
    clone=1
else
    cd "$git_dir" || exit
    git fetch
    git_main=$(git rev-parse main)
    git_origin=$(git rev-parse origin/main)
    cd - || exit

    if [[ "$git_main" != "$git_origin" ]]; then
        rm -rf "$git_dir"
        clone=1
    fi
fi

if [[ "$clone" = 1 ]]; then
    git clone "$git_url" "$git_dir"

    cp "${HOME}/.config/zsh/zshrc-pi" "${HOME}/.zshrc"
fi

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
