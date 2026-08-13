# PowerShell Shell Scripting Standards

- [CmdletBinding(SupportsShouldProcess)] and param() at top of every script/function.
- Set-StrictMode -Version 2.0.
- $ErrorActionPreference = 'Stop'; use try/catch for error handling.
- Use Write-Verbose / Write-Debug; never custom tracing flags.
- Global/script-scoped variables: minimal; declared immediately below param().
- PascalCase for all variables.
- Strongly typed parameters with validation attributes; use PSBoundParameters for forwarding.
- Use Write-Information for user-facing CLI output.
