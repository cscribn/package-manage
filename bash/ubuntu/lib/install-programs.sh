#!/bin/bash
# Non-package installations (add these first)

# update, autoremove, clean, upgrade all apt-get
apt-get update
apt-get dist-upgrade -y

# ssh - enable
systemctl enable --now ssh

# sleep, suspend, hibernate, hybrid-sleep - disable
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# laptop lid close actions - disable
sed -i 's/#\?HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sed -i 's/#\?HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
sed -i 's/#\?HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf
systemctl restart systemd-logind

# automatic login
TARGET_USER=${SUDO_USER:-$USER}
mkdir -p /etc/lightdm/lightdm.conf.d/
cat <<EOF > /etc/lightdm/lightdm.conf.d/50-autologin.conf
[Seat:*]
autologin-user=$TARGET_USER
autologin-user-timeout=0
EOF
