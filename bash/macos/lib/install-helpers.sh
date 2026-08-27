#!/opt/homebrew/bin/bash

[[ -n "${_INSTALL_HELPERS_LOADED:-}" ]] && return 0
_INSTALL_HELPERS_LOADED=1

PACKAGE_MANAGE_LOG_PREFIX="${PACKAGE_MANAGE_LOG_PREFIX:-package-manage}"

log_section() {
    echo "==> ${PACKAGE_MANAGE_LOG_PREFIX}: $1"
}

setup_brew_env() {
    export HOMEBREW_NO_ENV_HINTS=1
    export HOMEBREW_NO_UPDATE_REPORT_NEW=1
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}:/usr/local/bin:${HOME}/.local/bin"
}

brew_bootstrap() {
    brew update || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    export HOMEBREW_NO_AUTO_UPDATE=1
    brew upgrade --formula
}

brew_trust_tap() {
    local tap="$1"
    brew trust "${tap}" && brew tap "${tap}"
}

brew_install_formula() {
    local formula="$1"
    shift
    brew install "$@" "${formula}" || brew upgrade "$@" "${formula}"
}

_brew_cask_log() {
    local cask="$1"
    local label="${2:-cask}"
    echo "==> ${PACKAGE_MANAGE_LOG_PREFIX}: ${label} ${cask}"
}

brew_install_cask() {
    local cask="$1"
    _brew_cask_log "${cask}"
    refresh_sudo || { echo "sudo refresh failed before ${cask}" >&2; return 1; }
    brew install --cask "${cask}" || brew upgrade --cask "${cask}" || {
        echo "==> ${PACKAGE_MANAGE_LOG_PREFIX}: cask ${cask} FAILED (exit $?)" >&2
        return 1
    }
}

brew_upgrade_force_cask() {
    local cask="$1"
    _brew_cask_log "${cask}"
    refresh_sudo || { echo "sudo refresh failed before ${cask}" >&2; return 1; }
    brew install --cask "${cask}" || brew upgrade --force --cask "${cask}" || {
        echo "==> ${PACKAGE_MANAGE_LOG_PREFIX}: cask ${cask} FAILED (exit $?)" >&2
        return 1
    }
}

brew_ensure_cask() {
    local cask="$1"
    _brew_cask_log "${cask}" "cask (ensure)"
    refresh_sudo || { echo "sudo refresh failed before ${cask}" >&2; return 1; }
    brew list --cask "${cask}" >/dev/null || brew install --force --cask "${cask}" || {
        echo "==> ${PACKAGE_MANAGE_LOG_PREFIX}: cask ${cask} FAILED (exit $?)" >&2
        return 1
    }
}

nvm_install_lts_prune() {
    export NVM_DIR="${HOME}/.nvm"
    [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    [[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
    nvm install --lts
    nvm use --lts
    local node_versions_dir="${HOME}/.nvm/versions/node"
    if [[ -d "${node_versions_dir}" ]]; then
        (
            cd "${node_versions_dir}" || exit
            ls -dr * | tail -n +2 | xargs -I '{}' bash -c "export NVM_DIR=$HOME/.nvm; [ -s $NVM_DIR/nvm.sh ] && . $NVM_DIR/nvm.sh && nvm deactivate {} && nvm uninstall {}"
        )
    fi
}

git_clone_or_pull() {
    local url="$1"
    local dest="$2"
    local quiet_flag="${3:-}"
    local -a git_quiet=()

    if [[ "${quiet_flag}" == "--quiet" ]]; then
        git_quiet=(-q)
    fi

    if [[ -d "${dest}" ]]; then
        cd "${dest}" || return 1
        git pull "${git_quiet[@]}"
        cd - || return 1
    else
        git clone "${git_quiet[@]}" "${url}" "${dest}"
    fi
}

brew_cleanup() {
    brew autoremove
    brew cleanup
    brew doctor
}
