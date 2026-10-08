# Default Requirements

## All Projects

- Keep README.md (operator guide) and requirements.md synced with behavior and config updates.
- Apply YAGNI; prefer standard libraries and defer abstractions until logic repeats 3+ times.
- Functions must be cohesive (≤ 40 lines, low complexity); prune dead code and unused imports immediately.

## Non-Scripting Projects

- Use a single entry point command. Configure via env vars/files synced with example templates.
- Never hardcode secrets. Ignore secrets, local envs, and artifacts in `.gitignore`.
- Use system runtimes unless toolchains (e.g., `.python-version`) pin versions; ensure updates preserve build/run flows.
- Prefer explicit types over generic configs. Maintain actionable errors, keep tests synced with behavior, and add regression tests for bug fixes.
