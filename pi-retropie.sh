#!/bin/bash

# include
source ./_pi-default.sh

# retroarch info
cd /opt/retropie/configs/all/retroarch/cores || exit; \
git checkout -- px68k_libretro.info;\
cd - || exit

# retropie extras
mkdir -p "/home/pi/RetroPie-Setup/scriptmodules/libretrocores"

# lr-ppsspp-dev
mkdir -p "/home/pi/RetroPie-Setup/scriptmodules/emulators/ppsspp-dev"; \
curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/emulators/ppsspp-dev/tinker.armv7.cmake" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/refs/heads/master/scriptmodules/emulators/ppsspp-dev/tinker.armv7.cmake; \
curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/emulators/ppsspp-dev.sh" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/refs/heads/master/scriptmodules/emulators/ppsspp-dev.sh; \
curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-ppsspp-dev.sh" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/refs/heads/master/scriptmodules/libretrocores/lr-ppsspp-dev.sh

# lr-duckstation and lr-swanstation
curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-duckstation.sh" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/scriptmodules/libretrocores/lr-duckstation.sh; \
curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-swanstation.sh" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/scriptmodules/libretrocores/lr-swanstation.sh

# lr-yabasanshiro
mkdir -p "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-yabasanshiro"; \
curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-yabasanshiro/01_shader_hack_rpi4.diff" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/scriptmodules/libretrocores/lr-yabasanshiro/01_shader_hack_rpi4.diff; \
curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/libretrocores/lr-yabasanshiro.sh" https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/scriptmodules/libretrocores/lr-yabasanshiro.sh

# openbor
curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/ports/openbor-v6510-RPi0.sh" https://raw.githubusercontent.com/crcerror/OpenBOR-63xx-RetroPie-openbeta/master/scriptmodules/openbor-6xxx-RPizero/openbor-v6510-RPi0.sh; \
curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/ports/openbor-v6510-RPi3.sh" https://raw.githubusercontent.com/crcerror/OpenBOR-63xx-RetroPie-openbeta/master/scriptmodules/openbor-6xxx-RPi3/openbor-v6510-RPi3.sh; \
curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/ports/openbor-v6510-RPi4.sh" https://raw.githubusercontent.com/crcerror/OpenBOR-63xx-RetroPie-openbeta/master/scriptmodules/openbor-6xxx-RPi4/openbor-v6510-RPi4.sh

# mamedev
curl -Lo "/home/pi/RetroPie-Setup/scriptmodules/supplementary/mamedev.sh" https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-scriptmodules-00/supplementary/mamedev.sh

# .zshrc1
cp "${HOME}/.config/zsh/zshrc1-retropie" "${HOME}/.zshrc1"

# autoremove, clean
sudo apt autoremove -y; sudo apt clean -y
