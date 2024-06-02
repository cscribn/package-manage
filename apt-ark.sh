#!/bin/bash

# include
source ./_apt-ubuntu-default.sh

# properly link singe directory
unlink /opt/hypseus-singe/singe;ln -sfv /roms/daphne/roms /opt/hypseus-singe/singe

# enable ssh
sudo systemctl enable ssh
