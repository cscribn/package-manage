#!/opt/homebrew/bin/bash

[[ -n "${_INSTALL_HELPERS_LOADED:-}" ]] && return 0
_INSTALL_HELPERS_LOADED=1

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
