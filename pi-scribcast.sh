#!/bin/bash
# Non-package installations (add this last)
# bash ${HOME}/plexamp-install.sh
# Manual updates for after install/upgrade:
#
# cd ${HOME}/plexamp && bash ./upgrade.sh
# OR
# cd ${HOME} && bash ./plexamp-install.sh


# global variables
SCRIPT_NAME="$(basename "${0}")"
readonly SCRIPT_NAME
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly SCRIPT_DIR
HOSTNAME="$(hostname)"
readonly HOSTNAME

# include
source "${SCRIPT_DIR}/_pi-default.sh"

# asound.conf
sudo tee /etc/asound.conf > /dev/null << 'EOF'
pcm.!default {
    type plug
    slave.pcm "dmixer"
}

pcm.dmixer {
    type dmix
    ipc_key 1024
    ipc_key_add_uid false
    ipc_perm 0666
    slave {
        pcm "hw:1,0"
        period_time 0
        period_size 1024
        buffer_size 4096
        rate 44100
    }
    bindings {
        0 0
        1 1
    }
}

ctl.!default {
    type hw
    card 1
}
EOF

if [[ "$HOSTNAME" == "scribcast2" ]]; then
    # plexamp - https://gist.github.com/tgp-2/fc34c5389bc3e4ef332e28d9430b0ebf
    wget -O "${HOME}/plexamp-install.sh" https://gist.githubusercontent.com/tgp-2/65e6f2f637bc81df2c9fd9ba33f73bc6/raw/e7e9e47046c29a6090042a9a0a868a5bf7cf48be/plexamp-install.sh
elif [[ "$HOSTNAME" == "scribcast1" ]]; then
    # raspotify
    wget -O "${HOME}/raspotify-latest_arm64.deb" https://dtcooper.github.io/raspotify/raspotify-latest_arm64.deb; \
    sudo apt install -f "${HOME}/raspotify-latest_arm64.deb" -y; \
    sudo systemctl enable raspotify; \
    sudo systemctl start raspotify; \
    sudo sed -i 's/^#LIBRESPOT_DEVICE=.*/LIBRESPOT_DEVICE=plughw:1,0/' /etc/raspotify/conf
fi

# set volume to 85%. > bookworm uses 'Master', older versions use 'PCM'
(amixer -q sset Master 85% unmute || amixer -q sset PCM 85% unmute) >/dev/null 2>&1

# autoremove, clean
sudo apt autoremove -y; sudo apt clean -y
