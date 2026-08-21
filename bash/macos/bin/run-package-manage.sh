#!/opt/homebrew/bin/bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
readonly MAX_RUNTIME_SECONDS=$((6 * 60 * 60))
readonly LOG_FILE="${REPO_ROOT}/bash/macos/logs/package-manage.log"
readonly LOCK_FILE="${REPO_ROOT}/bash/macos/state/package-manage.lock"
readonly WORKFLOW_PGREP="${REPO_ROOT}/bash/macos/bin/run-package-manage.sh|${REPO_ROOT}/bash/macos/bin/install-chad.sh"

timestamp() {
    date "+%A, %B %d, %Y - %I:%M %p"
}

log() {
    echo "$*" >> "${LOG_FILE}"
}

process_runtime_seconds() {
    local pid="$1"
    local elapsed seconds=0

    elapsed="$(ps -p "${pid}" -o etime= 2>/dev/null | xargs || true)"
    [[ -n "${elapsed}" ]] || return 1

    if [[ "${elapsed}" =~ ^([0-9]+)-([0-9]{2}):([0-9]{2}):([0-9]{2})$ ]]; then
        seconds=$((10#${BASH_REMATCH[1]} * 86400 + 10#${BASH_REMATCH[2]} * 3600 + 10#${BASH_REMATCH[3]} * 60 + 10#${BASH_REMATCH[4]}))
    elif [[ "${elapsed}" =~ ^([0-9]{2}):([0-9]{2}):([0-9]{2})$ ]]; then
        seconds=$((10#${BASH_REMATCH[1]} * 3600 + 10#${BASH_REMATCH[2]} * 60 + 10#${BASH_REMATCH[3]}))
    elif [[ "${elapsed}" =~ ^([0-9]{2}):([0-9]{2})$ ]]; then
        seconds=$((10#${BASH_REMATCH[1]} * 60 + 10#${BASH_REMATCH[2]}))
    elif [[ "${elapsed}" =~ ^([0-9]+)$ ]]; then
        seconds=${BASH_REMATCH[1]}
    else
        return 1
    fi

    echo "${seconds}"
}

kill_process_tree() {
    local pid="$1"
    local child

    for child in $(pgrep -P "${pid}" 2>/dev/null || true); do
        kill_process_tree "${child}"
    done

    kill -TERM "${pid}" 2>/dev/null || true
}

kill_stale_pid() {
    local pid="$1"
    local runtime="$2"

    log "$(timestamp) - killing stale run (pid ${pid}, runtime ${runtime}s)"
    kill_process_tree "${pid}"
    sleep 2
    kill -KILL "${pid}" 2>/dev/null || true
}

# Returns 0 if clear to proceed, 1 if an active run is in progress.
handle_pid() {
    local pid="$1"
    local runtime

    kill -0 "${pid}" 2>/dev/null || return 0

    runtime="$(process_runtime_seconds "${pid}" || echo 0)"
    if (( runtime >= MAX_RUNTIME_SECONDS )); then
        kill_stale_pid "${pid}" "${runtime}"
        return 0
    fi

    return 1
}

clear_stale_runs() {
    local pid=""

    if [[ -f "${LOCK_FILE}" ]]; then
        pid="$(<"${LOCK_FILE}")"
        handle_pid "${pid}" || return 1
        rm -f "${LOCK_FILE}"
    fi

    while IFS= read -r pid; do
        [[ "${pid}" == "$$" ]] && continue
        handle_pid "${pid}" || return 1
    done < <(pgrep -f "${WORKFLOW_PGREP}" 2>/dev/null || true)

    return 0
}

run_workflow() {
    cd "${REPO_ROOT}"
    git pull
    "${SCRIPT_DIR}/install-chad.sh"
    pwsh ./pwsh/src/Private/Update-Modules-Mac.ps1
}

main() {
    mkdir -p "$(dirname "${LOG_FILE}")" "$(dirname "${LOCK_FILE}")"

    if ! clear_stale_runs; then
        log "$(timestamp) - skipped; another run is still active"
        exit 0
    fi

    echo "$(timestamp) - launchd start" > "${LOG_FILE}"

    (
        set +e
        local exit_code=0
        trap 'log "$(timestamp) - launchd finish (exit ${exit_code})"; rm -f "${LOCK_FILE}"' EXIT
        run_workflow >> "${LOG_FILE}" 2>&1
        exit_code=$?
        exit "${exit_code}"
    ) &

    echo "$!" > "${LOCK_FILE}"
}

main
