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

# RetroPie-Extra
curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-duckstation.sh" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/scriptmodules/libretrocores/lr-duckstation.sh

curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-swanstation.sh" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/scriptmodules/libretrocores/lr-swanstation.sh

curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-yabasanshiro.sh" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/scriptmodules/libretrocores/lr-yabasanshiro.sh

curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-yabasanshiro/01_shader_hack_rpi4.diff" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/scriptmodules/libretrocores/lr-yabasanshiro/01_shader_hack_rpi4.diff

sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt clean -y
