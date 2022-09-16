#!/bin/bash

source ./_apt-default.sh

sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt clean -y

# manual: nextdns
# sh -c 'sh -c "$(curl -sL https://nextdns.io/install)"'
