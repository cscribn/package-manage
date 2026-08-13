#Requires -Modules Microsoft.WinGet.Client

function Get-WinGetInstalledPackagesById {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Id
    )

    try {
        $packages = Get-WinGetPackage -Id $Id -ErrorAction Stop
        return @($packages)
    } catch {
        return @()
    }
}

function Resolve-WinGetDynamicPackageId {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Id,

        [Parameter(Mandatory=$true)]
        [string]$Like
    )

    $searchResults = Find-WinGetPackage $Id -ErrorAction SilentlyContinue
    if (-not $searchResults) {
        throw "No winget search results found for '$Id'."
    }

    $filtered = $searchResults | Where-Object { $_.Name -like $Like }
    if (-not $filtered) {
        throw "No winget search results found for '$Id' matching '$Like'."
    }

    $resolved = $filtered |
        Sort-Object -Property @{ Expression = { try { [version](Get-WinGetPackageVersion $_) } catch { [version]'0.0.0.0' } } } -Descending |
        Select-Object -First 1

    if (-not $resolved) {
        throw "Unable to resolve dynamic winget package id for '$Id'."
    }

    return $resolved.Id
}

function Resolve-WinGetUnknownPackageId {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Id
    )

    $searchResults = Find-WinGetPackage $Id -ErrorAction SilentlyContinue
    if (-not $searchResults) {
        throw "No winget search results found for '$Id'."
    }

    $resolved = $searchResults |
        Sort-Object -Property @{ Expression = { try { [version](Get-WinGetPackageVersion $_) } catch { [version]'0.0.0.0' } } } -Descending |
        Select-Object -First 1

    if (-not $resolved) {
        throw "Unable to resolve newest winget package id for '$Id'."
    }

    return $resolved.Id
}

function Invoke-WinGetCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$Arguments
    )

    try {
        $output = & winget @Arguments 2>&1
        $exitCode = $LASTEXITCODE
    } catch {
        $output = $_.Exception.Message
        $exitCode = 1
    }

    return [pscustomobject]@{
        Success = $exitCode -eq 0
        ExitCode = $exitCode
        Output = ($output | Out-String).Trim()
    }
}

function Get-WinGetPackageVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [psobject]$Package
    )

    if ($null -ne $Package.PSObject.Properties['Version']) {
        return $Package.Version
    }

    if ($null -ne $Package.PSObject.Properties['InstalledVersion']) {
        return $Package.InstalledVersion
    }

    if ($null -ne $Package.PSObject.Properties['AvailableVersion']) {
        return $Package.AvailableVersion
    }

    return $null
}

function Get-WinGetInstallAlreadyInstalledNoUpgrade {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [pscustomobject]$InstallResult,

        [Parameter(Mandatory=$true)]
        [string]$Id
    )

    if ($InstallResult.ExitCode -notin 1,-1978335189) {
        return $false
    }

    $installedPackages = Get-WinGetInstalledPackagesById -Id $Id
    return @($installedPackages).Count -gt 0
}

function Invoke-WinGetInstall {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Id
    )

    $args = @('install', '-e', '--silent', '--accept-package-agreements', '--accept-source-agreements', '--id', $Id)
    return Invoke-WinGetCommand -Arguments $args
}

function Invoke-WinGetUninstall {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Id,

        [Parameter(Mandatory=$false)]
        [switch]$AllVersions
    )

    $args = @('uninstall', '-e', '--accept-source-agreements', '--id', $Id)
    if ($AllVersions) {
        $args += '--all-versions'
    }

    return Invoke-WinGetCommand -Arguments $args
}

function Get-WinGetPackageFamilyPattern {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Id
    )

    if ($Id -match '^(.*?)(\.[0-9]+(?:\.[0-9]+)*)(\..*)$') {
        return "$($matches[1])*$($matches[3])"
    }

    return $Id
}

function Get-WinGetInstalledPackagesForCleanup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Id,

        [Parameter(Mandatory=$true)]
        [bool]$IsDynamic,

        [Parameter(Mandatory=$false)]
        [string]$Like
    )

    if (-not $IsDynamic) {
        return Get-WinGetInstalledPackagesById -Id $Id
    }

    $pattern = Get-WinGetPackageFamilyPattern -Id $Id
    $packages = Get-WinGetPackage -ErrorAction SilentlyContinue | Where-Object { $_.Id -like $pattern }
    if (@($packages).Count -gt 0) {
        return @($packages)
    }

    if ($Like) {
        $packages = Get-WinGetPackage -ErrorAction SilentlyContinue | Where-Object { $_.Name -like $Like }
        if (@($packages).Count -gt 0) {
            return @($packages)
        }
    }

    return Get-WinGetInstalledPackagesById -Id $Id
}

function Remove-OldWinGetPackageVersions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Id,

        [Parameter(Mandatory=$true)]
        [bool]$IsDynamic,

        [Parameter(Mandatory=$false)]
        [string]$Like
    )

    $installed = Get-WinGetInstalledPackagesForCleanup -Id $Id -IsDynamic $IsDynamic -Like $Like
    if (-not $installed -or @($installed).Count -le 1) {
        return
    }

    $sorted = @($installed) |
        Sort-Object -Property @{ Expression = { try { [version](Get-WinGetPackageVersion $_) } catch { [version]'0.0.0.0' } } } -Descending

    $packagesToRemove = $sorted | Select-Object -Skip 1
    foreach ($package in $packagesToRemove) {
        Write-Information "Uninstalling older package version $($package.Id) ($([string](Get-WinGetPackageVersion $package)))."
        $result = Invoke-WinGetUninstall -Id $package.Id -AllVersions
        if (-not $result.Success) {
            Write-Information "Failed to uninstall older package version $($package.Id): ExitCode=$($result.ExitCode) Output=$($result.Output)"
        }
    }
}

function Install-WinGetPackageClean {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Id,

        [Parameter(Mandatory=$false)]
        [ValidateSet('SkipIfInstalled','FixedId','DynamicId','UnknownId')]
        [string]$InstallType,

        [Parameter(Mandatory=$false)]
        [string]$Like
    )

    Set-StrictMode -Version 2.0
    $ErrorActionPreference = 'Stop'

    if (-not $PSBoundParameters.ContainsKey('InstallType')) {
        if ($Like) {
            $InstallType = 'DynamicId'
        } else {
            $InstallType = 'FixedId'
        }
    }

    try {
        $targetId = $Id
        switch ($InstallType) {
            'SkipIfInstalled' {
                $installedPackages = Get-WinGetInstalledPackagesById -Id $Id
                if (@($installedPackages).Count -gt 0) {
                    Write-Information "Application '$Id' is already installed."
                    return
                }

                Write-Information "Attempting to install '$Id'."
                $installResult = Invoke-WinGetInstall -Id $Id
            }
            'FixedId' {
                Write-Information "Attempting to install '$Id'."
                $installResult = Invoke-WinGetInstall -Id $Id
            }
            'DynamicId' {
                if (-not $Like) {
                    throw "InstallType 'DynamicId' requires a non-empty -Like value."
                }

                $resolvedId = Resolve-WinGetDynamicPackageId -Id $Id -Like $Like
                Write-Information "Attempting to install resolved package id '$resolvedId' for '$Id'."
                $targetId = $resolvedId
                $installResult = Invoke-WinGetInstall -Id $targetId
            }
            'UnknownId' {
                Write-Information "Attempting to install '$Id'."
                $resolvedId = Resolve-WinGetUnknownPackageId -Id $Id
                Write-Information "Attempting to install resolved package id '$resolvedId' for '$Id'."
                $targetId = $resolvedId
                $installResult = Invoke-WinGetInstall -Id $targetId
            }
            default {
                throw "Unsupported install type '$InstallType'."
            }
        }

        if (-not $installResult.Success) {
            if (Get-WinGetInstallAlreadyInstalledNoUpgrade -InstallResult $installResult -Id $targetId) {
                Write-Information "Application '$targetId' is already installed and no upgrade is pending"
                $installResult = [pscustomobject]@{
                    Success = $true
                    ExitCode = 0
                    Output = $installResult.Output
                }
            } else {
                Write-Information "Initial install failed for '$targetId'. Attempting fresh install."
                Write-Information "Attempting to uninstall '$targetId'."
                $uninstallResult = Invoke-WinGetUninstall -Id $targetId
                if (-not $uninstallResult.Success) {
                    Write-Information "Uninstall of '$targetId' returned nonzero exit code but retrying install anyway."
                }

                Write-Information "Attempting to install '$targetId' again."
                $installResult = Invoke-WinGetInstall -Id $targetId
            }
        }

        if (-not $installResult.Success) {
            if (Get-WinGetInstallAlreadyInstalledNoUpgrade -InstallResult $installResult -Id $targetId) {
                Write-Information "Application '$targetId' is already installed and no upgrade is pending on retry."
                $installResult = [pscustomobject]@{
                    Success = $true
                    ExitCode = 0
                    Output = $installResult.Output
                }
            }
        }

        if (-not $installResult.Success) {
            throw "Installation failed for '$targetId'. Output: $($installResult.Output)"
        }

        Write-Information "Cleaning up any older versions of '$targetId'."
        Remove-OldWinGetPackageVersions -Id $targetId -IsDynamic ($InstallType -eq 'DynamicId') -Like $Like
    } catch {
        Write-Information "Error in Install-WinGetPackageClean: $($_.Exception.Message)"
    }
}

