#!/bin/bash

source ./_apt-default.sh

sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt clean -y
