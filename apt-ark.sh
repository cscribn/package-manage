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

# wondershaper
# sudo apt install wondershaper -y
# sudo wondershaper eth0 10240 10240
# sudo wondershaper wlan0 10240 10240
