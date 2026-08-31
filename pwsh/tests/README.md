# Winget test collection

This directory holds two intentionally different workflows.

## Manual reproduction

Use the scripts in `manual-repro/` when a human has seen a package-install failure in the log and wants to rerun the exact scenario in isolation.

Examples:

```powershell
pwsh -NoLogo -NoProfile -File .\pwsh\tests\manual-repro\Repro-InstallUnknownId.ps1
pwsh -NoLogo -NoProfile -File .\pwsh\tests\manual-repro\Repro-UpgradeOnly.ps1
```

These scripts are intentionally narrow and copy-paste friendly. A human can read the log, copy the failing command, paste it into the script, and rerun it to inspect the output immediately.

## Pester regression suite

Use the suite in `pester/` for repeatable validation after fixes.

```powershell
$env:PACKAGE_MANAGE_ENABLE_WINGET_TESTS = '1'
Invoke-Pester .\pwsh\tests\pester\WingetUtils.Tests.ps1
```

## Naming

- `manual-repro/` = exact reproduction of a failing command from the log
- `pester/` = automated regression coverage of the same scenario set

## Notes

These are real winget integration tests that touch the local machine. Run them deliberately and treat failures as regression candidates for the logic in `pwsh/src/Private/WingetUtils.psm1`.
