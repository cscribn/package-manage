#!/bin/bash

# Non-apt installations (add/update these first)
# nextdns
# sh -c 'sh -c "$(curl -sL https://nextdns.io/install)"'

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
source ./_apt-pi-default.sh

# .zshrc1
cp "${HOME}/.config/zsh/zshrc1-pidns" "${HOME}/.zshrc1"
