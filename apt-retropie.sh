#!/bin/bash

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
