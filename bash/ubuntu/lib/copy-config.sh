#!/bin/bash

# bash
curl -sSLo "${HOME}/.bashrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/bash/bashrc-ubuntu

# oh-my-posh
git_dir="${HOME}/.config/oh-my-posh"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull -q; cd -; else git clone -q "https://github.com/cscribn/dotfiles-oh-my-posh.git" "$git_dir"; fi

# sleep, suspend, hibernate, hybrid-sleep - disable
sudo -A systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# ssh - enable
sudo -A systemctl enable --now ssh

# laptop lid close actions - disable
sudo -A sed -i 's/#\?HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sudo -A sed -i 's/#\?HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
sudo -A sed -i 's/#\?HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf
sudo -A systemctl restart systemd-logind

# login - automatic
TARGET_USER="${SUDO_USER:-${USER:-$(whoami)}}"
sudo -A mkdir -p /etc/lightdm/lightdm.conf.d/
sudo -A sh -c 'cat <<EOF > /etc/lightdm/lightdm.conf.d/50-autologin.conf
[Seat:*]
autologin-user=${TARGET_USER}
autologin-user-timeout=0
EOF'

# vim
curl -sSLo "${HOME}/.vimrc" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/vim/vimrc

# zsh
git_dir="${HOME}/.config/zsh"; if [[ -d "$git_dir" ]]; then cd "$git_dir"; git pull -q; cd -; else git clone -q "https://github.com/cscribn/dotfiles-zsh.git" "$git_dir"; fi
cp "${HOME}/.config/zsh/zshrc-ubuntu" "${HOME}/.zshrc"
