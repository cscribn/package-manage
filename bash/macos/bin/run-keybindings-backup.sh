#!/opt/homebrew/bin/bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
readonly SOURCE="${HOME}/Library/KeyBindings/DefaultKeyBinding.dict"
readonly DEST_DIR="${HOME}/projects/KeyBindings"
readonly DEST="${DEST_DIR}/DefaultKeyBinding.dict"
readonly LOG_FILE="${REPO_ROOT}/bash/macos/logs/keybindings-backup.log"

timestamp() {
    date "+%A, %B %d, %Y - %I:%M %p"
}

log() {
    echo "$(timestamp) - $*" >> "${LOG_FILE}"
}

main() {
    local exit_code=0

    mkdir -p "$(dirname "${LOG_FILE}")" "${DEST_DIR}"

    trap 'log "launchd finish (exit ${exit_code})"' EXIT

    echo "$(timestamp) - launchd start" > "${LOG_FILE}"

    if [[ ! -f "${SOURCE}" ]]; then
        log "error: source file not found: ${SOURCE}"
        exit_code=1
        exit "${exit_code}"
    fi

    if cp "${SOURCE}" "${DEST}"; then
        log "copied ${SOURCE} to ${DEST}"
    else
        log "error: failed to copy ${SOURCE} to ${DEST}"
        exit_code=1
        exit "${exit_code}"
    fi

    exit "${exit_code}"
}

main
