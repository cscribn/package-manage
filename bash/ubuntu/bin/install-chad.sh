#!/bin/bash

set -Eeuo pipefail

SCRIPT_NAME="$(basename "${0}")"
readonly SCRIPT_NAME
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
readonly SCRIPT_DIR
HOSTNAME="$(hostname)"
readonly HOSTNAME

# Use the same unattended-sudo pattern as the macOS installer.
if [[ -f "${SCRIPT_DIR}/../lib/sudo-askpass.sh" ]]; then
    source "${SCRIPT_DIR}/../lib/sudo-askpass.sh"
fi

# include
source "${SCRIPT_DIR}/../lib/install-programs.sh"
source "${SCRIPT_DIR}/../lib/copy-config.sh"

sudo apt-get install pipx -y
sudo apt-get install uv -y

# autoremove, clean
sudo -A apt-get autoremove -y -q
sudo -A apt-get clean -y -q
