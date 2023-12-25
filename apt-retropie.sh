#!/bin/bash

# settings
set -o nounset
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

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

# wondershaper
sudo apt install wondershaper -y
sudo wondershaper eth0 10240 10240
sudo wondershaper wlan0 10240 10240

# retropie extras
mkdir -p "/home/pi/RetroPie-Setup/scriptmodules/libretrocores"

curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-duckstation.sh" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/scriptmodules/libretrocores/lr-duckstation.sh

curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-swanstation.sh" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/scriptmodules/libretrocores/lr-swanstation.sh

curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-yabasanshiro.sh" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/scriptmodules/libretrocores/lr-yabasanshiro.sh

mkdir -p "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-yabasanshiro"
curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-yabasanshiro/01_shader_hack_rpi4.diff" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/scriptmodules/libretrocores/lr-yabasanshiro/01_shader_hack_rpi4.diff

curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/ports/openbor-v6510-RPi0.sh" https://raw.githubusercontent.com/crcerror/OpenBOR-63xx-RetroPie-openbeta/master/scriptmodules/openbor-6xxx-RPizero/openbor-v6510-RPi0.sh

curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/ports/openbor-v6510-RPi3.sh" https://raw.githubusercontent.com/crcerror/OpenBOR-63xx-RetroPie-openbeta/master/scriptmodules/openbor-6xxx-RPi3/openbor-v6510-RPi3.sh

curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/ports/openbor-v6510-RPi4.sh" https://raw.githubusercontent.com/crcerror/OpenBOR-63xx-RetroPie-openbeta/master/scriptmodules/openbor-6xxx-RPi4/openbor-v6510-RPi4.sh

curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/supplementary/mamedev.sh" https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-scriptmodules-00/supplementary/mamedev.sh

# .zshrc1
cp "${HOME}/.config/zsh/zshrc1-retropie" "${HOME}/.zshrc1"

sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt clean -y
