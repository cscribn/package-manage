# PowerShell Standards

- `[CmdletBinding(SupportsShouldProcess)]` and `param()` top of file/function.
- `Set-StrictMode -Version 2.0`.
- `$ErrorActionPreference = 'Stop'`; use `try/catch`.
- Minimal global/script variables, declared immediately below `param()`.
- Use `PascalCase` for variables and parameters.
- Strongly type parameters with validation attributes; forward via `$PSBoundParameters`.
- Use `Write-Verbose`/`Write-Debug` for trace/debug (no custom flags).
- Use `Write-Information` for CLI user output.
- Avoid aliases, abbreviating parameters, or deep pipeline chains; prefer explicit cmdlet names and readable sequential logic.
