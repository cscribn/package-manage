#!/opt/homebrew/bin/bash

[[ -n "${_INSTALL_HELPERS_LOADED:-}" ]] && return 0
_INSTALL_HELPERS_LOADED=1

apt_run() {
    sudo -A -E env \
        DEBIAN_FRONTEND=noninteractive \
        DEBCONF_NONINTERACTIVE_SEEN=true \
        apt-get -o Dpkg::Use-Pty=0 -qq "$@"
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

pipx_ensure_package() {
    local package="$1"
    local venv_python="${HOME}/.local/pipx/venvs/${package}/bin/python"

    if [[ -x "${venv_python}" ]]; then
        pipx upgrade "${package}" -q || pipx install "${package}" -q
    else
        pipx uninstall "${package}" -q 2>/dev/null || true
        pipx install "${package}" -q
    fi

    [[ -x "${venv_python}" ]]
}

pipx_ensure_inject() {
    local package="$1"
    shift
    pipx_ensure_package "${package}" && pipx inject --force "${package}" "$@"
}
