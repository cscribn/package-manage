#!/bin/bash

# Use a verified sudo askpass to keep the workflow unattended.
if [[ -n "${SUDO_ASKPASS:-}" ]]; then
    sudo -A -v
fi

apt_run install build-essential -y


# docker
apt_run install ca-certificates -y
sudo -A install -m 0755 -d /etc/apt/keyrings
sudo -A curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo -A chmod a+r /etc/apt/keyrings/docker.asc

CONTENT=$(cat <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
)

TARGET_FILE="/etc/apt/sources.list.d/docker.sources"

if [ ! -f "$TARGET_FILE" ] || [ "$(cat "$TARGET_FILE")" != "$CONTENT" ]; then
    echo "$CONTENT" | sudo -A tee "$TARGET_FILE" > /dev/null
fi

sudo -A apt update
apt_run install docker-ce -y
apt_run install docker-ce-cli -y
apt_run install containerd.io -y
apt_run install docker-buildx-plugin -y
apt_run install docker-compose-plugin -y
sudo -A groupadd -f docker

if ! id -nG "$USER" | grep -qw "docker"; then
    sudo -A usermod -aG docker "$USER"
fi

if ! groups | grep -qw "docker"; then
    exec sudo -A su -c "$0 $*" "$USER"
fi

# batocera
git_dir="${HOME}/batocera.linux"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull; cd -; else git clone "https://github.com/batocera-linux/batocera.linux.git" "$git_dir"; fi
