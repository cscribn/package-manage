#!/bin/bash
# Non-package installations (add these first)

# update, autoremove, clean, upgrade all apt-get
sudo apt-get update
sudo apt-get dist-upgrade -y

# ssh - enable
sudo systemctl enable --now ssh

# sleep, suspend, hibernate, hybrid-sleep - disable
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# laptop lid close actions - disable
sudo sed -i 's/#\?HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/#\?HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/#\?HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf
sudo systemctl restart systemd-logind

# automatic login
TARGET_USER=${SUDO_USER:-$USER}
sudo mkdir -p /etc/lightdm/lightdm.conf.d/
sudo bash -c "cat <<EOF > /etc/lightdm/lightdm.conf.d/50-autologin.conf
[Seat:*]
autologin-user=$TARGET_USER
autologin-user-timeout=0
EOF"
