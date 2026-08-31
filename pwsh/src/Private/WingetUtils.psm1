#Requires -Modules Microsoft.WinGet.Client

if (-not (Get-Variable -Name 'INSTALLED_OR_UPGRADED' -Scope Global -ErrorAction SilentlyContinue)) {
    New-Variable -Name "INSTALLED_OR_UPGRADED" -Value "SUCCESS: Install/Upgrade performed." -Option Constant -Scope Global
}

function Get-WinGetInstalledPackagesFromCli {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$Id,

        [Parameter(Mandatory=$false)]
        [string]$Like
    )

    try {
        $arguments = @('list', '--accept-source-agreements', '--source', 'winget')
        if ($Id) {
            $arguments += @('--id', $Id)
        }

        $output = & 'winget' @arguments 2>&1 | Out-String
        if (-not $output) {
            return @()
        }

        $lines = @($output -split "`r?`n")
        $packages = @()
        foreach ($line in $lines) {
            $trimmed = $line.Trim()
            if (-not $trimmed) {
                continue
            }

            if ($trimmed -match '^Name\s+Id\s+Version') {
                continue
            }

            if ($trimmed -match '^[-\s]+$') {
                continue
            }

            $match = [regex]::Match($trimmed, '^(?<Name>.+?)\s{2,}(?<Id>\S+)\s{2,}(?<Version>\S+)(?:\s{2,}(?<Available>\S+))?\s*$')
            if (-not $match.Success) {
                continue
            }

            $name = $match.Groups['Name'].Value.Trim()
            $id = $match.Groups['Id'].Value.Trim()
            $version = $match.Groups['Version'].Value.Trim()

            if (-not $name -or -not $id -or -not $version) {
                continue
            }

            if ($Id -and $id -ne $Id) {
                continue
            }

            if ($Like -and $name -notlike $Like -and $id -notlike $Like) {
                continue
            }

            $packages += [pscustomobject]@{
                Id = $id
                Name = $name
                Version = $version
                Source = 'winget'
            }
        }

        return @($packages)
    } catch {
        return @()
    }
}

function Merge-WinGetPackageCollections {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [object[]]$BasePackages,

        [Parameter(Mandatory=$false)]
        [object[]]$AdditionalPackages
    )

    $combined = @($BasePackages)
    foreach ($package in @($AdditionalPackages)) {
        $sameVersionExists = @($combined | Where-Object {
            $_.Id -eq $package.Id -and (Get-WinGetPackageVersion $_) -eq (Get-WinGetPackageVersion $package)
        })

        if (@($sameVersionExists).Count -eq 0) {
            $combined += $package
        }
    }

    return @($combined)
}

function Get-WinGetInstalledPackagesById {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Id
    )

    try {
        $packages = Get-WinGetPackage -Id $Id -ErrorAction Stop
        if (@($packages).Count -gt 0) {
            $combined = Merge-WinGetPackageCollections -BasePackages $packages -AdditionalPackages @(Get-WinGetInstalledPackagesFromCli -Id $Id)
            return @($combined)
        }
    } catch {
        # If the winget provider does not support filtering by msstore alias ID,
        # fall back to enumerating installed packages and matching the package Id.
    }

    try {
        $packages = Get-WinGetPackage -ErrorAction Stop | Where-Object { $_.Id -eq $Id }
        $combined = Merge-WinGetPackageCollections -BasePackages $packages -AdditionalPackages @(Get-WinGetInstalledPackagesFromCli -Id $Id)
        return @($combined)
    } catch {
        return @(Get-WinGetInstalledPackagesFromCli -Id $Id)
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
        $output = & 'winget' @Arguments 2>&1 | Out-String
        $exitCode = $LASTEXITCODE
        return [pscustomobject]@{
            Success = $exitCode -eq 0
            ExitCode = $exitCode
            Output = $output.Trim()
        }
    } catch {
        return [pscustomobject]@{
            Success = $false
            ExitCode = 1
            Output = ($_.Exception.Message | Out-String).Trim()
        }
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

    $installedPackages = Get-WinGetInstalledPackagesById -Id $Id
    return @($installedPackages).Count -gt 0
}

function Convert-WinGetInstallResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [pscustomobject]$InstallResult,

        [Parameter(Mandatory=$true)]
        [string]$Id,

        [Parameter(Mandatory=$false)]
        [string]$ActionLabel = 'already installed and no upgrade is pending.'
    )

    if ($InstallResult.Success) {
        return $InstallResult
    }

    if (Get-WinGetInstallAlreadyInstalledNoUpgrade -InstallResult $InstallResult -Id $Id) {
        Write-Warning "winget reported failure for '$Id' (ExitCode=$($InstallResult.ExitCode)). Package is installed; treating as success."
        return [pscustomobject]@{
            Success = $true
            ExitCode = 0
            Output = $InstallResult.Output
        }
    }

    return $InstallResult
}

function Invoke-WinGetInstall {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Id
    )

    $commandArguments = @('install', '-e', '--silent', '--accept-package-agreements', '--accept-source-agreements', '--id', $Id)
    return Invoke-WinGetCommand -Arguments $commandArguments
}

function Invoke-WinGetUpgrade {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Id
    )

    $commandArguments = @('upgrade', '-e', '--silent', '--accept-package-agreements', '--accept-source-agreements', '--id', $Id)
    return Invoke-WinGetCommand -Arguments $commandArguments
}

function Invoke-WinGetUninstall {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Id,

        [Parameter(Mandatory=$false)]
        [switch]$AllVersions
    )

    $commandArguments = @('uninstall', '-e', '--accept-source-agreements', '--id', $Id)
    if ($AllVersions) {
        $commandArguments += '--all-versions'
    }

    return Invoke-WinGetCommand -Arguments $commandArguments
}

function Get-WinGetPackageFamilyPattern {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Id
    )

    if ($Id -like '*.') {
        return "$Id*"
    }

    if ($Id -match '^(.*?)(\.[0-9]+(?:\.[0-9]+)*)(\..*)?$') {
        if ($matches[3]) {
            return "$($matches[1])*$($matches[3])"
        }

        return "$($matches[1])*"
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

    $candidates = [System.Collections.Generic.List[object]]::new()
    $pattern = Get-WinGetPackageFamilyPattern -Id $Id

    $familyPackages = @(Get-WinGetPackage -ErrorAction SilentlyContinue | Where-Object { $_.Id -like $pattern })
    foreach ($package in $familyPackages) {
        [void]$candidates.Add($package)
    }

    $cliFamilyPackages = @(Get-WinGetInstalledPackagesFromCli -Id $Id)
    foreach ($package in $cliFamilyPackages) {
        [void]$candidates.Add($package)
    }

    if ($Like) {
        $namePackages = @(Get-WinGetPackage -ErrorAction SilentlyContinue | Where-Object { $_.Name -like $Like })
        foreach ($package in $namePackages) {
            [void]$candidates.Add($package)
        }

        $cliNamePackages = @(Get-WinGetInstalledPackagesFromCli -Like $Like)
        foreach ($package in $cliNamePackages) {
            [void]$candidates.Add($package)
        }
    }

    $exactPackages = @(Get-WinGetInstalledPackagesById -Id $Id)
    foreach ($package in $exactPackages) {
        [void]$candidates.Add($package)
    }

    if ($candidates.Count -eq 0) {
        return @()
    }

    $uniquePackages = [System.Collections.Generic.List[object]]::new()
    foreach ($package in $candidates) {
        $key = "$($package.Id)|$([string](Get-WinGetPackageVersion $package))"
        $seen = $false
        foreach ($existing in $uniquePackages) {
            $existingKey = "$($existing.Id)|$([string](Get-WinGetPackageVersion $existing))"
            if ($existingKey -eq $key) {
                $seen = $true
                break
            }
        }

        if (-not $seen) {
            [void]$uniquePackages.Add($package)
        }
    }

    return @($uniquePackages)
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
        Write-Output "Uninstalling older package version $($package.Id) ($([string](Get-WinGetPackageVersion $package)))."
        $result = Invoke-WinGetUninstall -Id $package.Id -AllVersions
        if (-not $result.Success) {
            Write-Output "Failed to uninstall older package version $($package.Id): ExitCode=$($result.ExitCode) Output=$($result.Output)"
        }
    }
}

function Install-WinGetPackageClean {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Id,

        [Parameter(Mandatory=$false)]
        [ValidateSet('SkipIfInstalled','FixedId','DynamicId','UnknownId','UpgradeOnly')]
        [string]$InstallType,

        [Parameter(Mandatory=$false)]
        [string]$Like
    )

    Set-StrictMode -Version 2.0
    $ErrorActionPreference = 'Stop'
    $didInstallOrUpgrade = $false
    $preInstallPackages = @()

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
                    Write-Output "Application '$Id' is already installed."
                    return
                }

                Write-Output "Attempting to install '$Id'."
                $installResult = Invoke-WinGetInstall -Id $Id
            }
            'FixedId' {
                Write-Output "Attempting to install '$Id'."
                $preInstallPackages = Get-WinGetInstalledPackagesById -Id $Id
                $installResult = Invoke-WinGetInstall -Id $Id
            }
            'DynamicId' {
                if (-not $Like) {
                    throw "InstallType 'DynamicId' requires a non-empty -Like value."
                }

                $resolvedId = Resolve-WinGetDynamicPackageId -Id $Id -Like $Like
                Write-Output "Attempting to install resolved package id '$resolvedId' for '$Id'."
                $targetId = $resolvedId
                $preInstallPackages = Get-WinGetInstalledPackagesById -Id $targetId
                $installResult = Invoke-WinGetInstall -Id $targetId
            }
            'UnknownId' {
                Write-Output "Attempting to install '$Id'."
                $resolvedId = Resolve-WinGetUnknownPackageId -Id $Id
                Write-Output "Attempting to install resolved package id '$resolvedId' for '$Id'."
                $targetId = $resolvedId
                $preInstallPackages = Get-WinGetInstalledPackagesById -Id $targetId
                $installResult = Invoke-WinGetInstall -Id $targetId
            }
            'UpgradeOnly' {
                Write-Output "Attempting to upgrade '$Id'."
                $preInstallPackages = Get-WinGetInstalledPackagesById -Id $Id
                $installResult = Invoke-WinGetUpgrade -Id $Id
            }
            default {
                throw "Unsupported install type '$InstallType'."
            }
        }

        if (-not $installResult.Success) {
            $installResult = Convert-WinGetInstallResult -InstallResult $installResult -Id $targetId -ActionLabel 'already installed and no upgrade is pending.'
            if (-not $installResult.Success) {
                Write-Output "WARNING: Initial install failed for '$targetId'. Attempting fresh install."
                Write-Output "Attempting to uninstall '$targetId'."
                $uninstallResult = Invoke-WinGetUninstall -Id $targetId -AllVersions
                if (-not $uninstallResult.Success) {
                    Write-Output "WARNING: Uninstall of '$targetId' returned nonzero exit code but retrying install anyway."
                }

                Write-Output "Attempting to install '$targetId' again."
                $installResult = Invoke-WinGetInstall -Id $targetId
            }
        }

        if (-not $installResult.Success) {
            $installResult = Convert-WinGetInstallResult -InstallResult $installResult -Id $targetId -ActionLabel 'already installed and no upgrade is pending on retry.'
        }

        if (-not $installResult.Success) {
            Write-Output "ERROR: Final installation failure for '$targetId'. ExitCode=$($installResult.ExitCode) Output=$($installResult.Output)"
            throw "Installation failed for '$targetId'. ExitCode=$($installResult.ExitCode) Output: $($installResult.Output)"
        }

        Write-Output "Cleaning up any older versions of '$targetId'."
        $cleanupAsDynamic = $InstallType -in @('DynamicId','UnknownId')
        Remove-OldWinGetPackageVersions -Id $targetId -IsDynamic $cleanupAsDynamic -Like $Like

        $postInstallPackages = Get-WinGetInstalledPackagesById -Id $targetId
        if (@($postInstallPackages).Count -gt 0) {
            if (@($preInstallPackages).Count -eq 0) {
                $didInstallOrUpgrade = $true
            } else {
                $preVersions = @($preInstallPackages | ForEach-Object { [string](Get-WinGetPackageVersion $_) })
                $postVersions = @($postInstallPackages | ForEach-Object { [string](Get-WinGetPackageVersion $_) })
                if (@($postVersions | Where-Object { $_ -notin $preVersions }).Count -gt 0) {
                    $didInstallOrUpgrade = $true
                } elseif (@($postInstallPackages).Count -ne @($preInstallPackages).Count) {
                    $didInstallOrUpgrade = $true
                }
            }
        }

        if ($didInstallOrUpgrade) {
            return $INSTALLED_OR_UPGRADED
        }

        return
    } catch {
        Write-Output "ERROR: Caught exception in Install-WinGetPackageClean: $($_.Exception.Message)"
        throw
    }
}

Export-ModuleMember -Function * -Variable "INSTALLED_OR_UPGRADED"
