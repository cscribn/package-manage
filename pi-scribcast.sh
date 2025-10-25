#!/bin/bash
# Non-package installations (add this last)
# bash ${HOME}/plexamp-install.sh

# include
source ./_pi-default.sh

# plexamp - https://gist.github.com/tgp-2/fc34c5389bc3e4ef332e28d9430b0ebf
wget -O "${HOME}/plexamp-install.sh" https://gist.githubusercontent.com/tgp-2/65e6f2f637bc81df2c9fd9ba33f73bc6/raw/e7e9e47046c29a6090042a9a0a868a5bf7cf48be/plexamp-install.sh

# set volume to 85%. > bookworm uses 'Master', older versions use 'PCM'
(amixer -q sset Master 85% unmute || amixer -q sset PCM 85% unmute) >/dev/null 2>&1


# autoremove, clean
sudo apt autoremove -y; sudo apt clean -y

echo "Copy and paste the following to upgrade plexamp:"
echo "cd ${HOME} && bash ./plexamp-install.sh"
echo "After installation, make sure Settings -> Playback -> Audio Output -> Audio Device is set to headphones."
