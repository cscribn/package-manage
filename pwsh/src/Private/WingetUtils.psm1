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

    $commandArguments = @('install', '-e', '--silent', '--accept-package-agreements', '--accept-source-agreements', '--id', $Id)
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

    $result = Invoke-WinGetCommand -Arguments $commandArguments
    if (-not $result.Success -and Test-WinGetUninstallBlockedByAdmin -Output $result.Output) {
        Write-Output "WARNING: Winget uninstall failed because the package was installed for user scope and cannot be uninstalled while running elevated. Retrying without administrator privileges."
        $fallbackResult = Invoke-WinGetCommandAsStandardUser -Arguments $commandArguments
        if ($fallbackResult.Success) {
            return $fallbackResult
        }

        Write-Output "WARNING: Non-elevated uninstall retry failed: ExitCode=$($fallbackResult.ExitCode) Output=$($fallbackResult.Output)"
        return $fallbackResult
    }

    return $result
}

function Test-WinGetUninstallBlockedByAdmin {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Output
    )

    # Winget emits a specific failure when a user-scoped app is installed in the current user
    # profile and the caller is elevated. This should be retried in a standard shell.
    if (-not $Output) {
        return $false
    }

    return $Output -match '(?i)(user scope.*cannot.*uninstall|installed for user scope.*cannot be uninstalled|cannot be uninstalled.*administrator privileges)'
}

function Invoke-WinGetCommandAsStandardUser {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$Arguments
    )

    $stdoutPath = [IO.Path]::GetTempFileName()
    $stderrPath = [IO.Path]::GetTempFileName()
    $exitPath = [IO.Path]::GetTempFileName()
    $powershellPath = Join-Path $env:WINDIR 'System32\WindowsPowerShell\v1.0\powershell.exe'

    $escapedArgs = $Arguments | ForEach-Object {
        if ($_ -match '\s') {
            '"' + $_.Replace('"', '\"') + '"'
        } else {
            $_
        }
    }
    $wingetArguments = $escapedArgs -join ' '

    $innerCommand = "try { & winget $wingetArguments 2> \"$stderrPath\" | Out-String | Set-Content -LiteralPath \"$stdoutPath\"; $exitCode = $LASTEXITCODE } catch { $error[0].ToString() | Set-Content -LiteralPath \"$stderrPath\"; $exitCode = 1 }; Set-Content -LiteralPath \"$exitPath\" -Value $exitCode }"
    $encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($innerCommand))
    $shellArguments = "-NoProfile -NonInteractive -WindowStyle Hidden -EncodedCommand $encodedCommand"

    try {
        $shell = New-Object -ComObject Shell.Application
        $shellExecuteResult = $shell.ShellExecute($powershellPath, $shellArguments, '', 'open', 0)
        if ($shellExecuteResult -is [int] -and $shellExecuteResult -lt 32) {
            throw "ShellExecute failed with code $shellExecuteResult"
        }
    } catch {
        return [pscustomobject]@{
            Success = $false
            ExitCode = 1
            Output = "Failed to launch non-elevated Winget command: $($_.Exception.Message)"
        }
    }

    $timeout = [DateTime]::UtcNow.AddSeconds(30)
    while ((-not (Test-Path $exitPath)) -and ([DateTime]::UtcNow -lt $timeout)) {
        Start-Sleep -Milliseconds 200
    }

    try {
        $stdout = if (Test-Path $stdoutPath) { Get-Content -Path $stdoutPath -Raw -ErrorAction SilentlyContinue } else { '' }
        $stderr = if (Test-Path $stderrPath) { Get-Content -Path $stderrPath -Raw -ErrorAction SilentlyContinue } else { '' }
        $timedOut = -not (Test-Path $exitPath)
        $exitCode = if (-not $timedOut) { [int](Get-Content -Path $exitPath -Raw -ErrorAction SilentlyContinue) } else { 1 }
        $output = ($stdout + [Environment]::NewLine + $stderr).Trim()
        if ($timedOut) {
            $output = ($output + [Environment]::NewLine + 'Non-elevated Winget helper timed out.').Trim()
        }

        return [pscustomobject]@{
            Success = ($exitCode -eq 0 -and -not $timedOut)
            ExitCode = $exitCode
            Output = $output
        }
    } finally {
        Remove-Item -Path $stdoutPath, $stderrPath, $exitPath -Force -ErrorAction SilentlyContinue
    }
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
    }
}

Export-ModuleMember -Function * -Variable "INSTALLED_OR_UPGRADED"

