#!/bin/bash

[[ -n "${_INSTALL_HELPERS_LOADED:-}" ]] && return 0
_INSTALL_HELPERS_LOADED=1

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
