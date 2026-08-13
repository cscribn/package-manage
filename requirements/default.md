# Default requirements

## All Projects

- README.md as operator guide (build/run/env), not as requirements; README, requirements.md kept in sync with behavior/config changes.

## Projects containing languages other than/in addition to Bash and PowerShell

- One run command; env vars used for runtime modes.
- Config loads from .env; .env.example kept synced; secrets never hardcoded; .gitignore maintained for artifacts, secrets, local env.

## All Project Quality

- Prioritize YAGNI, reuse (codebase/stdlib/platform/deps); write minimum required code only if one-line solution doesn't exist.
- Abstraction is never premature; repeated logic extracted after appearing 3+ times.
- Functions kept small, cohesive (<= 40 lines, low complexity).
- Dead code removed, no unused imports.

## Quality for projects Projects containing languages other than/in addition to Bash and PowerShell

- Explicit types used over generic open-ended configs.
- Tests kept up to date with behavior; error messages are actionable.
- For each verified regression, a lightweight test is created/updated.
