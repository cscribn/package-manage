#!/opt/homebrew/bin/bash

SUDO_ASKPASS="${SUDO_ASKPASS:-${HOME}/.ssh/secrets/.supwd.sh}"
USERNAME="${USERNAME:-$(whoami)}"
export SUDO_ASKPASS USERNAME

if [[ ! -x "${SUDO_ASKPASS}" ]]; then
    echo "SUDO_ASKPASS script not found or not executable: ${SUDO_ASKPASS}" >&2
    exit 1
fi

if [[ -z "$("${SUDO_ASKPASS}")" ]]; then
    echo "SUDO_ASKPASS script returned an empty password: ${SUDO_ASKPASS}" >&2
    exit 1
fi

if ! sudo -A -v; then
    echo "sudo authentication failed via SUDO_ASKPASS: ${SUDO_ASKPASS}" >&2
    exit 1
fi
