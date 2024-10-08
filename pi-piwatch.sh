#!/bin/bash

# include
source ./_pi-default.sh

mkdir -p "${HOME}/opt"

# xpack
xpack_dir="${HOME}/opt/xpack-arm-none-eabi-gcc-10.2.1-1.1"; \
cd "${HOME}" || exit; \
wget "https://github.com/xpack-dev-tools/arm-none-eabi-gcc-xpack/releases/download/v10.2.1-1.1/xpack-arm-none-eabi-gcc-10.2.1-1.1-linux-arm.tar.gz" -O "xpack-arm-none-eabi-gcc-10.2.1-1.1-linux-arm.tar.gz"; \
cd - || exit; \
cd "${HOME}/opt" || exit; \
tar xvf "../xpack-arm-none-eabi-gcc-10.2.1-1.1-linux-arm.tar.gz" "$xpack_dir"; \
cd - || exit; \
export PATH=$PATH:/home/pi/opt/xpack-arm-none-eabi-gcc-10.2.1-1.1/bin/

# game-and-watch-backup
git_dir="${HOME}/opt/game-and-watch-backup"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/ghidraninja/game-and-watch-backup" "$git_dir"; fi

# xpm
sudo apt install npm -y; \
sudo npm install --global xpm@latest; \
xpm install --global @xpack-dev-tools/openocd@latest; \
sudo apt-get install binutils-arm-none-eabi -y; sudo apt-get install libftdi1 -y

# flashloader
git_dir="${HOME}/opt/game-and-watch-flashloader"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/ghidraninja/game-and-watch-flashloader" "$git_dir"; fi

# retro-go
git_dir="${HOME}/opt/game-and-watch-retro-go"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone --recurse-submodules "https://github.com/kbeckmann/game-and-watch-retro-go.git" "$git_dir"; fi; \
cd "$git_dir" || exit; \
python3 -m pip install -r requirements.txt; \
cd - || exit

# .zshrc1
cp "${HOME}/.config/zsh/zshrc1-piwatch" "${HOME}/.zshrc1"
