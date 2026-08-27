#!/opt/homebrew/bin/bash

# Non-package installations (add/update these first)
# filezilla
# google drive - don't use brew
# pdfgear
# screen shot: In Finder locate Application/Utilities/ScreenShot.app, grab a hold of the app, and drag/drop onto the Dock.
# sudo git lfs install --system
# twg: bash <(curl -fsSL https://teamwork-graph.atlassian.com/cli/install)

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

setup_brew_env

# Check password before proceeding
if dscl /Search -authonly "$USERNAME" "$($SUDO_ASKPASS)"; then
    echo "Password is correct."
else
    echo "Password is incorrect."
    exit 1
fi

source "${script_dir}/../lib/sudo-askpass.sh"
source "${script_dir}/../lib/install-helpers.sh"

brew_bootstrap

# taps
brew_trust_tap deskflow/tap
brew_trust_tap powershell/tap
brew_trust_tap snyk/tap
brew_trust_tap theseal/blank-screensaver

log_section "formulae"

# formulae
brew_install_formula bash
brew_install_formula bat
brew_install_formula blank-screensaver
brew_install_formula btop
brew_install_formula bun
brew_install_formula curl
brew_install_formula deskflow
brew_install_formula docker-compose
brew_install_formula fastfetch
brew_install_formula ffmpeg
brew_install_formula fzf
brew_install_formula gh
brew_install_formula gifsicle
brew_install_formula git
brew_install_formula git-lfs; git lfs install
brew_install_formula gradle
brew_install_formula granted
brew_install_formula helm
brew_install_formula jq
brew_install_formula libgit2@1.7
brew_install_formula libpq; brew link --force libpq
brew_install_formula lsd
brew_install_formula maven
brew_install_formula mermaid-cli
brew_install_formula nmap

# nvm and node
brew_install_formula nvm
nvm_install_lts_prune

brew_install_formula jandedobbeleer/oh-my-posh/oh-my-posh --formula; oh-my-posh disable notice
brew_install_formula perl
brew_install_formula pipx; pipx ensurepath
(brew_install_formula powershell; launchctl setenv POWERSHELL_UPDATECHECK Off) && brew link powershell
brew_install_formula pre-commit
brew_install_formula python
brew_install_formula ripgrep
brew_install_formula sbcl # steel bank common lisp
brew_install_formula snyk
brew_install_formula temurin --cask
brew_install_formula uv
brew_install_formula vim
brew_install_formula wget
brew_install_formula yarn
brew_install_formula zsh

log_section "casks"
refresh_sudo

# casks
brew_install_cask adobe-acrobat-reader || true
brew_install_cask alt-tab || true
brew_install_cask antigravity-cli || true
brew_install_cask bbedit || true
brew_install_cask claude || true
brew_ensure_cask cursor || true
brew_install_cask dbeaver-community || true
brew_install_cask docker-desktop || true
brew_ensure_cask firefox || true
brew_install_cask font-meslo-lg-nerd-font || true
brew_install_cask gimp || true
brew_install_cask git-credential-manager || true
brew_install_cask github || true
brew_ensure_cask google-chrome || true
brew_ensure_cask google-chrome@beta || true
brew_install_cask gpg-suite || true
brew_install_cask hammerspoon || true
brew_install_cask hex-fiend || true
brew_install_cask iterm2 || true
brew_install_cask itsycal || true
brew_install_cask krita || true
refresh_sudo
brew_install_cask libreoffice || true
brew_install_cask microsoft-auto-update || true
brew_ensure_cask microsoft-edge || true
brew_install_cask pgadmin4 || true
brew_install_cask postgres-unofficial || true
brew_upgrade_force_cask postman || true
brew_install_cask the-unarchiver || true
brew_ensure_cask visual-studio-code || true
brew_install_cask vlc || true
brew_install_cask wireshark-app || true

log_section "post-brew (npm/pipx/twg/copy/cleanup)"

# docker
docker info >/dev/null 2>&1 && docker pull crystaldba/postgres-mcp

# netskope certificates
if [[ -f "${HOME}/netskope-cert-bundle.pem" && ! -f "${HOME}/.ssl/certs/ca_bundle.pem" ]]; then
    cp /opt/homebrew/etc/ca-certificates/cert.pem "${HOME}/.ssl/certs/ca_bundle.pem"
    cat "${HOME}/netskope-cert-bundle.pem" >> "${HOME}/.ssl/certs/ca_bundle.pem"
    "${JAVA_HOME}/bin/keytool" -import -keystore "${JAVA_HOME}/lib/security/cacerts" -file "${HOME}/.ssl/certs/ca_bundle.pem" -storepass changeit -noprompt
fi

# npm
npm config set fund false
npm install -g @pilatos/bitbucket-cli -q
npm install -g datadog-mcp-server -q

# pipx
pipx upgrade busylight-for-humans -q 2>/dev/null || pipx install busylight-for-humans -q; pipx inject --force busylight-for-humans uvicorn
pipx upgrade ipython -q 2>/dev/null || pipx install ipython -q
pipx upgrade openai-whisper -q 2>/dev/null || pipx install openai-whisper -q

# teamwork graph
twg update

# zsh
git_clone_or_pull "https://github.com/zsh-users/zsh-autosuggestions" "${HOME}/.zsh/zsh-autosuggestions" --quiet
git_clone_or_pull "https://github.com/zsh-users/zsh-syntax-highlighting.git" "${HOME}/.zsh/zsh-syntax-highlighting" --quiet

source "${script_dir}/../lib/copy-projects-chad.sh"
source "${script_dir}/../lib/copy-config.sh"

# cleanup
brew_cleanup
