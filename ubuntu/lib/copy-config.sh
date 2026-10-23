#!/bin/bash

# dotfiles-misc
git_clone_or_pull "https://github.com/cscribn/dotfiles-misc.git" "${HOME}/.config/dotfiles-misc" --quiet

# bash
cp "${HOME}/.config/dotfiles-misc/bash/bashrc-ubuntu" "${HOME}/.bashrc"
cp "${HOME}/.config/dotfiles-misc/bash/inputrc-ubuntu" "${HOME}/.inputrc"

# laptop lid close actions - disable
sudo -A sed -i 's/#\?HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sudo -A sed -i 's/#\?HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
sudo -A sed -i 's/#\?HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf
sudo -A systemctl restart systemd-logind

# login - automatic
TARGET_USER="${SUDO_USER:-${USER:-$(whoami)}}"
sudo -A mkdir -p /etc/lightdm/lightdm.conf.d/
sudo -A tee /etc/lightdm/lightdm.conf.d/50-autologin.conf > /dev/null <<EOF
[Seat:*]
autologin-user=${TARGET_USER}
autologin-user-timeout=0
EOF

# lsd
mkdir -p "${HOME}/.config/lsd"
cp "${HOME}/.config/dotfiles-misc/lsd/config.yaml" "${HOME}/.config/lsd/config.yaml"
cp "${HOME}/.config/dotfiles-misc/lsd/icons.yaml" "${HOME}/.config/lsd/icons.yaml"

# oh-my-posh
git_clone_or_pull "https://github.com/cscribn/dotfiles-oh-my-posh.git" "${HOME}/.config/oh-my-posh" --quiet

# sleep, suspend, hibernate, hybrid-sleep - disable
sudo -A systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# ssh - enable
sudo -A systemctl enable --now ssh

# vim
cp "${HOME}/.config/dotfiles-misc/vim/vimrc" "${HOME}/.vimrc"

# zsh
cp "${HOME}/.config/dotfiles-misc/zsh/zshrc-ubuntu" "${HOME}/.zshrc"
[ "$SHELL" != "$(which zsh)" ] && sudo -A chsh -s "$(which zsh)" "$USER"
