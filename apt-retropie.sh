#!/bin/bash

source ./_apt-default.sh

# wondershaper
rm -rf ~/wondershaper
git clone https://github.com/magnific0/wondershaper.git ~/wondershaper

ls -t /home/pi/RetroPie-Setup/logs/*.gz | tail -n +2 | xargs rm --
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt clean -y
