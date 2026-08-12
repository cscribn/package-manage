function Install-WinGetPackageClean {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Id,

        [switch]$SkipIfInstalled
    )

    Write-Verbose "Processing WinGet Package ID: $Id"

    # Fetch installed packages cleanly into an array
    $installed = @(Get-WinGetPackage -Id $Id -ErrorAction SilentlyContinue)

    # Check if package exists and skip condition is set
    if ($SkipIfInstalled -and $installed.Count -gt 0) {
        Write-Verbose "Package $Id is already installed. Skipping due to -SkipIfInstalled flag."
        return
    }

    $CommonInstallArgs = @(
        "-e",
        "--id", $Id,
        "--scope", "machine",
        "--silent",
        "--accept-package-agreements",
        "--accept-source-agreements"
    )

    $UninstallArgs = @(
        "-e",
        "--id", $Id,
        "--scope", "machine",
        "--silent"
    )

    if ($installed.Count -gt 1) {
        # Safely sort versions (falls back to string sorting if [version] cast fails)
        $sorted = $installed | Sort-Object {
            try { [version]$_.InstalledVersion } catch { $_.InstalledVersion }
        }

        # Select all older versions except the newest
        $olderVersions = $sorted | Select-Object -SkipLast 1

        # Uninstall older versions individually
        foreach ($pkg in $olderVersions) {
            Write-Verbose "Removing older version: $($pkg.InstalledVersion)"
            Start-Process winget -ArgumentList (@("uninstall", "--version", $pkg.InstalledVersion) + $UninstallArgs) -NoNewWindow -Wait
        }
    }

    # Attempt initial installation/upgrade
    Write-Verbose "Attempting to install/upgrade package: $Id"
    $process = Start-Process winget -ArgumentList (@("install") + $CommonInstallArgs) -NoNewWindow -Wait -PassThru

    # WinGet exit codes to treat as success (0 = Success, -1978335189 = Already up to date)
    $successCodes = @(0, -1978335189)

    # Fallback on failure: wipe all versions and retry clean install
    if ($process.ExitCode -notin $successCodes) {
        Write-Warning "Install failed (Exit Code: $($process.ExitCode)). Attempting fresh reinstall..."

        # Strip all installed versions
        Start-Process winget -ArgumentList (@("uninstall", "--all-versions") + $UninstallArgs) -NoNewWindow -Wait

        # Fresh reinstall
        $retryProcess = Start-Process winget -ArgumentList (@("install") + $CommonInstallArgs) -NoNewWindow -Wait -PassThru

        if ($retryProcess.ExitCode -notin $successCodes) {
            Throw "Failed to install $Id after clean-up. Exit Code: $($retryProcess.ExitCode)"
        }
    }
}
