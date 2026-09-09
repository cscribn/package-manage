#!/bin/bash

# Use a verified sudo askpass to keep the workflow unattended.
if [[ -n "${SUDO_ASKPASS:-}" ]]; then
    sudo -A -v
fi

sudo apt-get install build-essential -y -q
sudo apt-get install docker.io -y -q

sudo groupadd -f docker

if ! id -nG "$USER" | grep -qw "docker"; then
    sudo usermod -aG docker "$USER"
fi

if ! groups | grep -qw "docker"; then
    exec su -c "$0 $*" "$USER"
fi

# batocera
git_dir="${HOME}/batocera.linux"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/batocera-linux/batocera.linux.git" "$git_dir"; fi
