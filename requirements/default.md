# Default requirements

## All Projects

- README.md acts strictly as an operator guide (build/run/env); keep README.md and requirements.md in sync with all behavior and config updates.
- Prioritize YAGNI and standard library reuse; write minimal code, avoiding premature abstraction until logic repeats 3+ times.
- Keep functions cohesive (≤ 40 lines, low complexity); remove dead code and unused imports immediately.

## Non-Scripting Projects

- Single entry point command; runtime configured via .env (kept synced with .env.example).
- Never hardcode secrets; maintain .gitignore for secrets, local envs, and artifacts.
- Bind to system-default runtimes; ensure system updates do not break build/run flows.
- Prefer explicit types over generic configs.  Maintain actionable error messages, keep tests synced with behavior, add regression tests for all fixed bugs.
