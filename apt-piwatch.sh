#!/bin/bash

# Non-apt installations (add/update these first)

# settings
set -o nounset
set -o pipefail
[[ "${TRACE-0}" == "1" ]] && set -o xtrace

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

sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt clean -y
