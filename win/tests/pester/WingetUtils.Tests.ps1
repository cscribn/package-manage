[CmdletBinding()]
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

if (-not $env:PACKAGE_MANAGE_ENABLE_WINGET_TESTS) {
    Write-Host 'Skipping winget regression tests. Set PACKAGE_MANAGE_ENABLE_WINGET_TESTS=1 to run them.'
    return
}

$modulePath = Join-Path $PSScriptRoot '..\..\src\Private\WingetUtils.psm1'
Import-Module $modulePath -Force

$matrixPath = Join-Path $PSScriptRoot '..\fixtures\WingetPackageMatrix.psd1'
$matrix = Import-PowerShellDataFile -Path $matrixPath

function Assert-WinGetInstallOutcome {
    param(
        [AllowNull()]
        [object]$Result,

        [Parameter(Mandatory = $true)]
        [string]$PackageId,

        [Parameter(Mandatory = $true)]
        [bool]$OriginallyInstalled
    )

    $outputText = if ($null -eq $Result) { '' } elseif ($Result -is [string]) { [string]$Result } else { [string]::Join("`n", @($Result)) }

    if ($OriginallyInstalled) {
        if ($outputText -notmatch 'already installed|treating as success|Attempting to install|Attempting to upgrade|Cleaning up any older versions') {
            throw "Expected install status output for '$PackageId' to reflect a no-op or success path, but got: '$outputText'."
        }
    }
    else {
        if ($outputText -notmatch 'Attempting to install|Attempting to upgrade|Cleaning up any older versions') {
            throw "Expected install status output for '$PackageId' to show an install or upgrade attempt, but got: '$outputText'."
        }
    }
}

function Test-WinGetInstalled {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PackageId
    )

    return (@(Get-WinGetInstalledPackagesById -Id $PackageId)).Count -gt 0
}

Describe 'Winget install helper' {
    Context 'Primary flows' {
        It 'installs Git.Git using a fixed ID and leaves it installed' {
            $case = $matrix.Primary.FixedId
            $wasInstalledBefore = Test-WinGetInstalled -PackageId $case.Id

            $result = Install-WinGetPackageClean -Id $case.Id -InstallType $case.InstallType

            Assert-WinGetInstallOutcome -Result $result -PackageId $case.Id -OriginallyInstalled $wasInstalledBefore
            if (-not (Test-WinGetInstalled -PackageId $case.Id)) {
                throw "Package '$($case.Id)' is not installed after the fixed-id install check."
            }
        }

        It 'resolves and installs Python using an unknown ID' {
            $case = $matrix.Primary.UnknownId
            $resolvedId = Resolve-WinGetUnknownPackageId -Id $case.Id
            $wasInstalledBefore = Test-WinGetInstalled -PackageId $resolvedId

            $result = Install-WinGetPackageClean -Id $case.Id -InstallType $case.InstallType

            Assert-WinGetInstallOutcome -Result $result -PackageId $resolvedId -OriginallyInstalled $wasInstalledBefore
            if (-not (Test-WinGetInstalled -PackageId $resolvedId)) {
                throw "Package '$resolvedId' is not installed after the unknown-id install check."
            }
        }

        It 'upgrades Microsoft PowerShell using UpgradeOnly' {
            $case = $matrix.Primary.UpgradeOnly
            $wasInstalledBefore = Test-WinGetInstalled -PackageId $case.Id

            $result = Install-WinGetPackageClean -Id $case.Id -InstallType $case.InstallType

            Assert-WinGetInstallOutcome -Result $result -PackageId $case.Id -OriginallyInstalled $wasInstalledBefore
            if (-not (Test-WinGetInstalled -PackageId $case.Id)) {
                throw "Package '$($case.Id)' is not installed after the upgrade-only check."
            }
        }
    }

    Context 'Secondary flows' {
        It 'skips installation when the package is already present' {
            $case = $matrix.Secondary.SkipIfInstalled
            $wasInstalledBefore = Test-WinGetInstalled -PackageId $case.Id

            $result = Install-WinGetPackageClean -Id $case.Id -InstallType $case.InstallType

            $outputText = if ($null -eq $result) { '' } elseif ($result -is [string]) { [string]$result } else { [string]::Join("`n", @($result)) }

            if ($wasInstalledBefore) {
                if ($outputText -notmatch 'already installed|treating as success') {
                    throw "Expected skip-if-installed output for '$($case.Id)' to mention that it is already installed, but got '$outputText'."
                }
            }
            else {
                if ($outputText -notmatch 'Attempting to install|Cleaning up any older versions') {
                    throw "Expected skip-if-installed output for '$($case.Id)' to show an install attempt, but got '$outputText'."
                }
            }

            if (-not (Test-WinGetInstalled -PackageId $case.Id)) {
                throw "Package '$($case.Id)' is not installed after the skip-if-installed check."
            }
        }

        It 'resolves a dynamic ID using Like and leaves the package installed' {
            $case = $matrix.Secondary.DynamicId
            $resolvedId = Resolve-WinGetDynamicPackageId -Id $case.Id -Like $case.Like
            $wasInstalledBefore = Test-WinGetInstalled -PackageId $resolvedId

            $result = Install-WinGetPackageClean -Id $case.Id -InstallType $case.InstallType -Like $case.Like

            Assert-WinGetInstallOutcome -Result $result -PackageId $resolvedId -OriginallyInstalled $wasInstalledBefore
            if (-not (Test-WinGetInstalled -PackageId $resolvedId)) {
                throw "Package '$resolvedId' is not installed after the dynamic-id install check."
            }
        }
    }
}
