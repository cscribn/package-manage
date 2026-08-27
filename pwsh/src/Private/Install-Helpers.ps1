function Get-PipxVenvName {
    param(
        [Parameter(Mandatory)]
        [string]$Package
    )

    # pipx venv directories use the base package name (extras like [default] are omitted).
    if ($Package -match '^(.*?)\[.*\]$') {
        return $Matches[1]
    }

    return $Package
}

function Get-PipxVenvPythonPath {
    param(
        [Parameter(Mandatory)]
        [string]$Package
    )

    $venvName = Get-PipxVenvName -Package $Package
    $candidateRoots = @()

    if ($Env:PIPX_HOME) {
        $candidateRoots += $Env:PIPX_HOME
    } else {
        $candidateRoots += Join-Path $Env:LOCALAPPDATA 'pipx\pipx'
        $candidateRoots += Join-Path $Env:USERPROFILE '.local\pipx'
    }

    foreach ($root in $candidateRoots) {
        $venvPython = Join-Path $root "venvs\$venvName\Scripts\python.exe"
        if (Test-Path -LiteralPath $venvPython) {
            return $venvPython
        }
    }

    $defaultRoot = if ($Env:PIPX_HOME) { $Env:PIPX_HOME } else { Join-Path $Env:LOCALAPPDATA 'pipx\pipx' }
    return Join-Path $defaultRoot "venvs\$venvName\Scripts\python.exe"
}

function Ensure-PipxPackage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Package
    )

    $venvPython = Get-PipxVenvPythonPath -Package $Package

    if (Test-Path -LiteralPath $venvPython) {
        pipx upgrade $Package -q
        if ($LASTEXITCODE -ne 0) {
            pipx install $Package -q
        }
    } else {
        pipx uninstall $Package -q 2>$null
        pipx install $Package -q
    }

    $venvPython = Get-PipxVenvPythonPath -Package $Package
    return Test-Path -LiteralPath $venvPython
}

function Ensure-PipxInject {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Package,
        [Parameter(Mandatory)]
        [string[]]$InjectPackages
    )

    if (-not (Ensure-PipxPackage -Package $Package)) {
        return $false
    }

    pipx inject --force $Package @InjectPackages
    return $LASTEXITCODE -eq 0
}
