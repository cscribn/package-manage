#Requires -Modules Microsoft.WinGet.Client

if (-not (Get-Variable -Name 'INSTALLED_OR_UPGRADED' -Scope Global -ErrorAction SilentlyContinue)) {
    New-Variable -Name "INSTALLED_OR_UPGRADED" -Value "Install/Upgrade performed." -Option Constant -Scope Global
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
            return @($packages)
        }
    } catch {
        # If the winget provider does not support filtering by msstore alias ID,
        # fall back to enumerating installed packages and matching the package Id.
    }

    try {
        $packages = Get-WinGetPackage -ErrorAction Stop | Where-Object { $_.Id -eq $Id }
        return @($packages)
    } catch {
        return @()
    }
}

function Get-WinGetNewestPackageId {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [psobject[]]$Packages
    )

    if (-not $Packages) {
        return $null
    }

    $resolved = $Packages |
        Sort-Object -Property @{ Expression = { try { [version](Get-WinGetPackageVersion $_) } catch { [version]'0.0.0.0' } } } -Descending |
        Select-Object -First 1

    return $resolved.Id
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

    $resolvedId = Get-WinGetNewestPackageId -Packages $filtered
    if (-not $resolvedId) {
        throw "Unable to resolve dynamic winget package id for '$Id'."
    }

    return $resolvedId
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

    $resolvedId = Get-WinGetNewestPackageId -Packages $searchResults
    if (-not $resolvedId) {
        throw "Unable to resolve newest winget package id for '$Id'."
    }

    return $resolvedId
}

function Invoke-WinGetCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$Arguments
    )

    $argumentsText = $Arguments | ForEach-Object {
        if ($_ -match '\s') { "`"$_`"" } else { $_ }
    } | Join-String ' '

    try {
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = 'winget'
        $startInfo.Arguments = $argumentsText
        $startInfo.RedirectStandardOutput = $true
        $startInfo.RedirectStandardError = $true
        $startInfo.UseShellExecute = $false
        $startInfo.CreateNoWindow = $true

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $startInfo
        $process.Start() | Out-Null

        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()
        $process.WaitForExit()

        $exitCode = $process.ExitCode
        $output = ($stdout + [Environment]::NewLine + $stderr).Trim()
    } catch {
        $output = $_.Exception.Message
        $exitCode = 1
    }

    return [pscustomobject]@{
        Success = $exitCode -eq 0
        ExitCode = $exitCode
        Output = $output
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
        [ValidateSet('SkipIfInstalled','FixedId','DynamicId','UnknownId')]
        [string]$InstallType,

        [Parameter(Mandatory=$false)]
        [string]$Like
    )

    Set-StrictMode -Version 2.0
    $originalErrorActionPreference = $ErrorActionPreference
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
                $preInstallPackages = @()
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
            default {
                throw "Unsupported install type '$InstallType'."
            }
        }

        if (-not $installResult.Success) {
            if (Get-WinGetInstallAlreadyInstalledNoUpgrade -InstallResult $installResult -Id $targetId) {
                Write-Output "Application '$targetId' is already installed and no upgrade is pending."
                $installResult = [pscustomobject]@{
                    Success = $true
                    ExitCode = 0
                    Output = $installResult.Output
                }
            } else {
                Write-Output "WARNING: Initial install failed for '$targetId'. Attempting fresh install."
                Write-Output "Attempting to uninstall '$targetId'."
                $uninstallResult = Invoke-WinGetUninstall -Id $targetId
                if (-not $uninstallResult.Success) {
                    Write-Output "WARNING: Uninstall of '$targetId' returned nonzero exit code but retrying install anyway."
                }

                Write-Output "Attempting to install '$targetId' again."
                $installResult = Invoke-WinGetInstall -Id $targetId
            }
        }

        if (-not $installResult.Success) {
            if (Get-WinGetInstallAlreadyInstalledNoUpgrade -InstallResult $installResult -Id $targetId) {
                Write-Output "Application '$targetId' is already installed and no upgrade is pending on retry."
                $installResult = [pscustomobject]@{
                    Success = $true
                    ExitCode = 0
                    Output = $installResult.Output
                }
            }
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
    } finally {
        $ErrorActionPreference = $originalErrorActionPreference
    }
}

Export-ModuleMember -Function * -Variable "INSTALLED_OR_UPGRADED"

