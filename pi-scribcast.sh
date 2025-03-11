#!/bin/bash
# Non-package installations (add this last)
# bash ${HOME}/plexamp-install.sh

# include
source ./_pi-default.sh

# plexamp - https://gist.github.com/tgp-2/fc34c5389bc3e4ef332e28d9430b0ebf
wget https://gist.githubusercontent.com/tgp-2/65e6f2f637bc81df2c9fd9ba33f73bc6/raw/e7e9e47046c29a6090042a9a0a868a5bf7cf48be/plexamp-install.sh

# autoremove, clean
sudo apt autoremove -y; sudo apt clean -y
