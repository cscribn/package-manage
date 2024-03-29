#!/bin/bash

# Non-apt installations (add/update these first)

# settings
set -o nounset
set -o pipefail
[[ "${TRACE-0}" == "1" ]] && set -o xtrace

# variables
declare script_name
script_name=$(basename "${0}")

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ./${script_name}"
	exit
fi

# include
source ./_apt-default.sh

mkdir -p "${HOME}/opt"

# xpack
xpack_dir="${HOME}/opt/xpack-arm-none-eabi-gcc-10.2.1-1.1"

if [[ ! -d "$xpack_dir" ]]; then
	cd "${HOME}" || exit
	wget "https://github.com/xpack-dev-tools/arm-none-eabi-gcc-xpack/releases/download/v10.2.1-1.1/xpack-arm-none-eabi-gcc-10.2.1-1.1-linux-arm.tar.gz" -O "xpack-arm-none-eabi-gcc-10.2.1-1.1-linux-arm.tar.gz"
	cd - || exit

	cd "${HOME}/opt" || exit
	tar xvf "../xpack-arm-none-eabi-gcc-10.2.1-1.1-linux-arm.tar.gz" "$xpack_dir"
	cd - || exit
fi

export PATH=$PATH:/home/pi/opt/xpack-arm-none-eabi-gcc-10.2.1-1.1/bin/

# game-and-watch-backup
git_dir="${HOME}/opt/game-and-watch-backup"

if [[ -d "$git_dir" ]]; then
	cd "$git_dir" || exit
	git fetch
	git_main=$(git rev-parse main)
	git_origin=$(git rev-parse origin/main)
	cd - || exit

	if [[ "$git_main" != "$git_origin" ]]; then
		rm -rf "$git_dir"
	fi
fi

# xpm
npm install --global xpm@latest
xpm install --global @xpack-dev-tools/openocd@latest
sudo apt-get install binutils-arm-none-eabi libftdi1

# flashloader
git_dir="${HOME}/opt/game-and-watch-flashloader"

if [[ -d "$git_dir" ]]; then
	cd "$git_dir" || exit
	git fetch
	git_main=$(git rev-parse main)
	git_origin=$(git rev-parse origin/main)
	cd - || exit

	if [[ "$git_main" != "$git_origin" ]]; then
		rm -rf "$git_dir"
	fi
fi

# retro-go
git_dir="${HOME}/opt/game-and-watch-retro-go"
git_url="https://github.com/kbeckmann/game-and-watch-retro-go.git"
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
	git clone --recurse-submodules "$git_url" "$git_dir"
fi

cd "${HOME}/opt/game-and-watch-retro-go" || exit
python3 -m pip install -r requirements.txt
cd - || exit

# .zshrc1
cp "${HOME}/.config/zsh/zshrc1-piwatch" "${HOME}/.zshrc1"
