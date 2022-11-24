#!/bin/bash

# Non-apt installations (add/update these first)
# nextdns
# sh -c 'sh -c "$(curl -sL https://nextdns.io/install)"'

source ./_apt-default.sh

sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt clean -y
