#!/bin/bash
# Non-package installations (add these first)

# Use a verified sudo askpass to keep the workflow unattended.
if [[ -n "${SUDO_ASKPASS:-}" ]]; then
    sudo -A -v
fi

# update, autoremove, clean, upgrade all apt-get
sudo -A apt-get update -q
sudo -A apt-get dist-upgrade -y -q

# ssh - enable
sudo -A systemctl enable --now ssh

# sleep, suspend, hibernate, hybrid-sleep - disable
sudo -A systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# laptop lid close actions - disable
sudo -A sed -i 's/#\?HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sudo -A sed -i 's/#\?HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
sudo -A sed -i 's/#\?HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf
sudo -A systemctl restart systemd-logind

# automatic login
TARGET_USER="${SUDO_USER:-${USER:-$(whoami)}}"
sudo -A mkdir -p /etc/lightdm/lightdm.conf.d/
sudo -A sh -c 'cat <<EOF > /etc/lightdm/lightdm.conf.d/50-autologin.conf
[Seat:*]
autologin-user=${TARGET_USER}
autologin-user-timeout=0
EOF'
