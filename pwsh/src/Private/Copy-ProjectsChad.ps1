function Initialize-SparseCheckoutRepo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$RepoDir,
        [Parameter(Mandatory)]
        [string]$RepoUrl,
        [Parameter(Mandatory)]
        [string]$SparsePath
    )

    if (Test-Path -LiteralPath (Join-Path $RepoDir ".git")) {
        Push-Location $RepoDir
        $Remotes = git remote
        if ($Remotes -notcontains "origin") {
            git remote add origin $RepoUrl
        }
        git pull -q origin
        $SparsePaths = git sparse-checkout list
        if ($SparsePaths -notcontains $SparsePath) {
            git sparse-checkout add $SparsePath
        }
        Pop-Location
    } else {
        git init -q $RepoDir
        Push-Location $RepoDir
        git checkout -q -b main
        git remote add origin $RepoUrl
        git sparse-checkout set $SparsePath
        git pull -q --set-upstream origin main
        Pop-Location
    }
}

function Initialize-FullCloneRepo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$RepoDir,
        [Parameter(Mandatory)]
        [string]$RepoUrl
    )

    if (Test-Path -LiteralPath (Join-Path $RepoDir ".git")) {
        Push-Location $RepoDir
        $Remotes = git remote
        if ($Remotes -notcontains "origin") {
            git remote add origin $RepoUrl
        }
        git pull -q origin main
        Pop-Location
    } else {
        git clone -q -b main $RepoUrl $RepoDir
    }
}

function Update-SkillsFromSource {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SourceDir,
        [Parameter(Mandatory)]
        [string]$ProjectRoot
    )

    if (-not (Test-Path -LiteralPath $SourceDir -PathType Container)) {
        return $false
    }

    $HasChanges = $false
    foreach ($SourceSkillDir in Get-ChildItem -LiteralPath $SourceDir -Directory) {
        $TargetSkillDir = Join-Path $ProjectRoot ".agents\skills\$($SourceSkillDir.Name)"
        if (-not (Test-Path -LiteralPath $TargetSkillDir -PathType Container)) {
            continue
        }

        foreach ($SourceFile in Get-ChildItem -LiteralPath $SourceSkillDir.FullName -Recurse -File -Force) {
            $RelativePath = [System.IO.Path]::GetRelativePath($SourceSkillDir.FullName, $SourceFile.FullName)
            $Target = Join-Path $TargetSkillDir $RelativePath
            if (-not (Test-Path -LiteralPath $Target -PathType Leaf)) {
                continue
            }
            if ((Get-FileHash -LiteralPath $SourceFile.FullName).Hash -ne (Get-FileHash -LiteralPath $Target).Hash) {
                New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Target) | Out-Null
                Copy-Item -LiteralPath $SourceFile.FullName -Destination $Target -Force
                $HasChanges = $true
            }
        }
    }

    return $HasChanges
}

# agent instructions
$src = "$Env:USERPROFILE\.config\ai\AGENTS.md"
Get-ChildItem -Path "$Env:USERPROFILE\Projects" -Directory | ForEach-Object {
    $target = Join-Path $_.FullName "AGENTS.md"
    if (Test-Path $target) {
        if ((Get-FileHash $target).Hash -ne (Get-FileHash $src).Hash) {
            Copy-Item -Path $src -Destination $target -Force
            Push-Location $_.FullName
            git add AGENTS.md
            git commit -m "Update agent instructions"
            if (git remote | Select-String -Pattern "^origin$" -Quiet) {
                git push origin HEAD
            }
            Pop-Location
        }
    }
}
Clear-Content -Path $src

# skills
$DotfilesGitDir = "$Env:USERPROFILE\.config\dotfiles-misc"
$DotfilesRepoUrl = "https://github.com/cscribn/dotfiles-misc"
Initialize-SparseCheckoutRepo -RepoDir $DotfilesGitDir -RepoUrl $DotfilesRepoUrl -SparsePath ".agents/skills"

$DotfilesSkillsDir = Join-Path $DotfilesGitDir ".agents\skills"
Get-ChildItem -Path "$Env:USERPROFILE\Projects" -Directory | ForEach-Object {
    $ProjectRoot = $_.FullName
    if (-not (Test-Path -LiteralPath (Join-Path $ProjectRoot ".agents\skills") -PathType Container)) {
        return
    }
    $HasChanges = $false
    if (Update-SkillsFromSource -SourceDir $DotfilesSkillsDir -ProjectRoot $ProjectRoot) { $HasChanges = $true }
    if ($HasChanges) {
        Push-Location $ProjectRoot
        git add .agents/skills/
        git commit -m "Update agent skills"
        if (git remote | Select-String -Pattern "^origin$" -Quiet) { git push origin HEAD }
        Pop-Location
    }
}

# requirements
$srcDir = "$Env:USERPROFILE\.config\dotfiles-misc\requirements"
$mdFiles = Get-ChildItem -Path $srcDir -Filter *.md
Get-ChildItem -Path "$Env:USERPROFILE\Projects" -Directory | ForEach-Object {
    $projectRoot = $_.FullName
    $hasChanges = $false
    foreach ($file in $mdFiles) {
        $src = $file.FullName
        $fileName = $file.Name
        $target = Join-Path $projectRoot "requirements\$fileName"
        if (Test-Path $target) {
            if ((Get-FileHash $target).Hash -ne (Get-FileHash $src).Hash) {
                Copy-Item -Path $src -Destination $target -Force
                $hasChanges = $true
            }
        }
    }
    if ($hasChanges) {
        Push-Location $projectRoot
        git add requirements/
        git commit -m "Update requirements"
        if (git remote | Select-String -Pattern "^origin$" -Quiet) { git push origin HEAD }
        Pop-Location
    }
}
