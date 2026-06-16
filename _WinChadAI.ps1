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

# tokensave
$src = "$Env:USERPROFILE\.copilot\mcp-config.json"; `
Get-ChildItem -Path "$Env:USERPROFILE\Projects" -Directory | ForEach-Object { `
    $mcpFile = Join-Path $_.FullName ".vscode\mcp.json"; `
    if ((Test-Path (Join-Path $_.FullName ".tokensave")) -and (Test-Path $mcpFile)) { `
        $obj = (Get-Content "$src" -Raw) | jq -c '.mcpServers.tokensave'; `
        $json = (Get-Content $mcpFile -Raw) | jq --argjson obj "$obj" '.servers.tokensave = $obj'; `
        $json -split "`r`n|`n" | ForEach-Object { `
            if ($_ -match '^(\s+)(.*)$') { `
                $tabs = "`t" * [math]::Floor($Matches[1].Length / 2); `
                $tabs + $Matches[2]; `
            } else { $_ } `
        } | Out-File $mcpFile -Encoding utf8NoBOM; `
        Push-Location $_.FullName; `
        tokensave sync; `
        Pop-Location; `
    } `
}
