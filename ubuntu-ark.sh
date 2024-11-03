#!/bin/bash

# include
source ./_ubuntu-default.sh

# properly link singe directory
unlink /opt/hypseus-singe/singe; ln -sfv /roms/daphne/roms /opt/hypseus-singe/singe

# enable ssh
sudo systemctl enable ssh

# .zshrc1
cp "${HOME}/.config/zsh/zshrc1-ark" "${HOME}/.zshrc1"

# autoremove, clean
sudo apt autoremove -y; sudo apt clean -y
