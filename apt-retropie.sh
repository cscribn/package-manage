#!/bin/bash

# settings
set -o errexit
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
rm -rf ~/wondershaper
git clone https://github.com/magnific0/wondershaper.git ~/wondershaper

# RetroPie-Extra
curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-duckstation.sh" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/scriptmodules/libretrocores/lr-duckstation.sh

curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-swanstation.sh" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/scriptmodules/libretrocores/lr-swanstation.sh

curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-yabasanshiro.sh" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/scriptmodules/libretrocores/lr-yabasanshiro.sh

curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-yabasanshiro/01_shader_hack_rpi4.diff" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/scriptmodules/libretrocores/lr-yabasanshiro/01_shader_hack_rpi4.diff

ls -t /home/pi/RetroPie-Setup/logs/*.gz | tail -n +2 | xargs rm --
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt clean -y
