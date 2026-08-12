#Requires -Modules Microsoft.WinGet.Client

function Install-WinGetPackageClean {
    [CmdletBinding(DefaultParameterSetName = 'FixedId')]
    param (
        # Use for fixed-ID apps (e.g., "7zip.7zip")
        [Parameter(Mandatory = $true, ParameterSetName = 'FixedId', ValueFromPipelineByPropertyName = $true)]
        [string]$Id,

        # Use for major-version-suffixed apps (e.g., "Python.Python")
        [Parameter(Mandatory = $true, ParameterSetName = 'DynamicId', ValueFromPipelineByPropertyName = $true)]
        [string]$DynamicBaseId,

        [switch]$SkipIfInstalled,

        [switch]$PassThru
    )

    process {
        # Locate WinGet binary executable cleanly (handles SYSTEM context / Intune execution)
        $WinGetExe = (Get-Command winget.exe -ErrorAction SilentlyContinue).Path
        if (-not $WinGetExe) {
            $WinGetExe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe" -ErrorAction SilentlyContinue | Select-Object -Last 1 -ExpandProperty Path
        }
        if (-not $WinGetExe) {
            $WinGetExe = "winget" # Fallback to PATH environment variable
        }

        $UninstallArgs = @(
            "-e",
            "--scope", "machine",
            "--silent",
            "--accept-source-agreements"
        )

        # Resolve Dynamic Base ID
        if ($PSCmdlet.ParameterSetName -eq 'DynamicId') {
            Write-Host "Resolving latest package for dynamic base ID '$DynamicBaseId'..."

            $escapedBase = [regex]::Escape($DynamicBaseId)

            # Handle PackageIdentifier vs Id property mapping cleanly
            $availablePackages = @(Find-WinGetPackage -Query $DynamicBaseId -ErrorAction SilentlyContinue |
                Where-Object {
                    $pkgId = if ($_.PackageIdentifier) { $_.PackageIdentifier } else { $_.Id }
                    $pkgId -match "^$escapedBase\.\d+"
                })

            # Force update local source index if initial package resolution returns empty
            if ($availablePackages.Count -eq 0) {
                Write-Host "No local index matches found. Refreshing WinGet sources..."
                Start-Process $WinGetExe -ArgumentList @("source", "update") -NoNewWindow -Wait

                $availablePackages = @(Find-WinGetPackage -Query $DynamicBaseId -ErrorAction SilentlyContinue |
                    Where-Object {
                        $pkgId = if ($_.PackageIdentifier) { $_.PackageIdentifier } else { $_.Id }
                        $pkgId -match "^$escapedBase\.\d+"
                    })
            }

            if ($availablePackages.Count -eq 0) {
                Throw "No packages found matching base ID '$DynamicBaseId'."
            }

            # Extract ID cleanly and safely sort version string suffixes
            $targetPackage = $availablePackages | Sort-Object {
                $pkgId = if ($_.PackageIdentifier) { $_.PackageIdentifier } else { $_.Id }
                $verString = $pkgId -replace "^$escapedBase\.", ''

                # Normalize short version strings like "3.9" into valid "3.9.0" version objects
                if ($verString -match '^\d+\.\d+$') { $verString += ".0" }
                try { [version]$verString } catch { $verString }
            } | Select-Object -Last 1

            $Id = if ($targetPackage.PackageIdentifier) { $targetPackage.PackageIdentifier } else { $targetPackage.Id }
            Write-Host "Resolved dynamic target ID to: '$Id'"
        }

        # Fetch currently installed versions for the target ID cleanly as an array
        $installed = @(Get-WinGetPackage -Id $Id -ErrorAction SilentlyContinue)

        # Skip early if target is already present
        if ($SkipIfInstalled -and $installed.Count -gt 0) {
            Write-Host "Package $Id is already installed. Skipping due to -SkipIfInstalled flag."
            if ($PassThru) { return $installed }
            return
        }

        # Clean up older major version packages (e.g., remove Python 3.11 when installing 3.12)
        if ($PSCmdlet.ParameterSetName -eq 'DynamicId') {
            $escapedBase = [regex]::Escape($DynamicBaseId)
            $legacyInstalled = @(Get-WinGetPackage -ErrorAction SilentlyContinue | Where-Object {
                $_.Id -match "^$escapedBase\.\d+" -and $_.Id -ne $Id
            })

            foreach ($legacyPkg in $legacyInstalled) {
                Write-Host "Uninstalling older major version package ID: $($legacyPkg.Id)"
                $unProc = Start-Process $WinGetExe -ArgumentList (@("uninstall", "--id", $legacyPkg.Id) + $UninstallArgs) -NoNewWindow -Wait -PassThru
                if ($unProc.ExitCode -ne 0) {
                    Write-Warning "Failed to cleanly uninstall legacy package '$($legacyPkg.Id)' (Exit Code: $($unProc.ExitCode))."
                }
            }
        }

        $CommonInstallArgs = @(
            "-e",
            "--id", $Id,
            "--scope", "machine",
            "--silent",
            "--accept-package-agreements",
            "--accept-source-agreements"
        )

        # Clean up minor/build versions within the target ID
        if ($installed.Count -gt 1) {
            $sorted = $installed | Sort-Object {
                $ver = if ($_.InstalledVersion) { $_.InstalledVersion } else { $_.Version }
                if ($ver -match '^\d+\.\d+$') { $ver += ".0" }
                try { [version]$ver } catch { $ver }
            }

            $olderVersions = $sorted | Select-Object -SkipLast 1

            foreach ($pkg in $olderVersions) {
                $ver = if ($pkg.InstalledVersion) { $pkg.InstalledVersion } else { $pkg.Version }
                Write-Host "Removing older version of current ID: $ver"
                $unProc = Start-Process $WinGetExe -ArgumentList (@("uninstall", "--id", $Id, "--version", $ver) + $UninstallArgs) -NoNewWindow -Wait -PassThru
                if ($unProc.ExitCode -ne 0) {
                    Write-Warning "Failed to uninstall minor version '$ver' of '$Id' (Exit Code: $($unProc.ExitCode))."
                }
            }
        }

        # Perform Installation/Upgrade
        Write-Host "Attempting to install/upgrade package: $Id"
        $process = Start-Process $WinGetExe -ArgumentList (@("install") + $CommonInstallArgs) -NoNewWindow -Wait -PassThru

        # Success Codes: 0 = OK, -1978335189 = Already Installed, -1978335180 = No Update Found, -1978335188 = Reboot Required
        $successCodes = @(0, -1978335189, -1978335180, -1978335188)

        # Fallback on failure
        if ($process.ExitCode -notin $successCodes) {
            Write-Warning "Install failed (Exit Code: $($process.ExitCode)). Attempting fresh reinstall..."

            # Strip remnant installations without logging errors if app wasn't partially installed
            Start-Process $WinGetExe -ArgumentList (@("uninstall", "--all-versions", "--id", $Id) + $UninstallArgs) -NoNewWindow -Wait

            $retryProcess = Start-Process $WinGetExe -ArgumentList (@("install") + $CommonInstallArgs) -NoNewWindow -Wait -PassThru

            if ($retryProcess.ExitCode -notin $successCodes) {
                Write-Warning "Failed to install $Id after clean-up. Exit Code: $($retryProcess.ExitCode)"
            }
        }

        if ($PassThru) {
            return Get-WinGetPackage -Id $Id -ErrorAction SilentlyContinue
        }
    }
}
