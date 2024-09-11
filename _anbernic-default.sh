#!/bin/bash
# Non-package installations (add these first)

# oh-my-posh
mkdir -p /userdata/system/oh-my-posh
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm -O /userdata/system/oh-my-posh/oh-my-posh; \
chmod +x /userdata/system/oh-my-posh/oh-my-posh; /userdata/system/oh-my-posh/oh-my-posh disable notice

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ); \
source "${script_dir}/_anbernic-default-config.sh"
