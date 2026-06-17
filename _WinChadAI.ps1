# copilot instructions
$src = "$Env:USERPROFILE\.copilot\copilot-instructions.md"; `
Get-ChildItem -Path "$Env:USERPROFILE\Projects" -Directory | ForEach-Object { `
    $target = Join-Path $_.FullName ".github\copilot-instructions.md"; `
    if (Test-Path $target) { `
        if ((Get-FileHash $target).Hash -ne (Get-FileHash $src).Hash) { `
            Copy-Item -Path $src -Destination $target -Force; `
            Push-Location $_.FullName; `
            git add .github/copilot-instructions.md; `
            git commit -m "Update copilot instructions"; `
            if (git remote | Select-String -Pattern "^origin$" -Quiet) { `
                git push origin HEAD; `
            } `
            Pop-Location; `
        } `
    } `
} `
Clear-Content -Path $src
