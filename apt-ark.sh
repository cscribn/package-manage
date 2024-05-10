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
source ./_apt-ubuntu-default.sh

# properly link singe directory
unlink /opt/hypseus-singe/singe
ln -sfv /roms/daphne/roms /opt/hypseus-singe/singe

# enable ssh
sudo systemctl enable ssh
