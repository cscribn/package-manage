#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
readonly MAX_RUNTIME_SECONDS=$((6 * 60 * 60))
readonly LOG_DIR="${SCRIPT_DIR}/logs"
readonly LOG_FILE="${LOG_DIR}/package-manage.log"
readonly STATE_DIR="${SCRIPT_DIR}/state"
readonly LOCK_FILE="${STATE_DIR}/package-manage.lock"
readonly WORKFLOW_PGREP="${REPO_ROOT}/bash/ubuntu/run-package-manage.sh|${REPO_ROOT}/bash/ubuntu/install-chad.sh|${REPO_ROOT}/bash/ubuntu/bin/install-chad.sh"

timestamp() {
    date "+%A, %B %d, %Y - %I:%M %p"
}

log() {
    echo "$(timestamp) - $*" >> "${LOG_FILE}"
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

    log "killing stale run (pid ${pid}, runtime ${runtime}s)"
    kill_process_tree "${pid}"
    sleep 2
    kill -KILL "${pid}" 2>/dev/null || true
}

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

run_step() {
    local label="$1"
    shift
    local exit_code=0

    log "${label} start"
    set +e
    "$@" >> "${LOG_FILE}" 2>&1
    exit_code=$?
    set -e
    log "${label} finish (exit ${exit_code})"
    return "${exit_code}"
}

resolve_install_script() {
    if [[ -x "${REPO_ROOT}/bash/ubuntu/bin/install-chad.sh" ]]; then
        echo "${REPO_ROOT}/bash/ubuntu/bin/install-chad.sh"
        return 0
    fi

    if [[ -x "${REPO_ROOT}/bash/ubuntu/install-chad.sh" ]]; then
        echo "${REPO_ROOT}/bash/ubuntu/install-chad.sh"
        return 0
    fi

    echo "${REPO_ROOT}/bash/ubuntu/bin/install-chad.sh"
    return 1
}

run_workflow() {
    local install_script
    local exit_code=0
    local step_exit=0

    cd "${REPO_ROOT}"

    set +e
    git pull >> "${LOG_FILE}" 2>&1
    step_exit=$?
    set -e
    if (( step_exit != 0 )); then
        log "git pull finish (exit ${step_exit})"
        exit_code=1
    fi

    install_script="$(resolve_install_script || true)"
    if [[ -z "${install_script}" || ! -f "${install_script}" ]]; then
        log "install script not found at ${install_script:-<unset>}"
        return 1
    fi

    run_step "install-chad.sh" "${install_script}" || exit_code=1
    return "${exit_code}"
}

main() {
    local exit_code=0

    mkdir -p "${LOG_DIR}" "${STATE_DIR}"

    if ! clear_stale_runs; then
        log "skipped; another run is still active"
        exit 0
    fi

    echo "$$" > "${LOCK_FILE}"
    trap 'log "systemd finish (exit ${exit_code})"; rm -f "${LOCK_FILE}"' EXIT

    echo "$(timestamp) - systemd start" > "${LOG_FILE}"

    set +e
    run_workflow
    exit_code=$?
    set -e

    exit "${exit_code}"
}

if [[ "${1:-}" == "--workflow" ]]; then
    set +e
    run_workflow
    exit_code=$?
    set -e
    exit "${exit_code}"
fi

main
