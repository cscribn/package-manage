#!/bin/bash

# global variables
SCRIPT_NAME="$(basename "${0}")"
readonly SCRIPT_NAME
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly SCRIPT_DIR
HOSTNAME="$(hostname)"
readonly HOSTNAME

# include
source "${SCRIPT_DIR}/../lib/install-programs.sh"

# autoremove, clean
apt-get autoremove -y; apt-get clean -y
