# lsd
$path = "$Env:USERPROFILE\Projects\gaming-utils\sync\mirror\batocera\userdata\system\custom\usr\bin"; `
$asset = (Invoke-RestMethod "https://api.github.com/repos/lsd-rs/lsd/releases/latest").assets | `
    Where-Object { $_.name -match 'lsd-.*-x86_64-unknown-linux-musl\.tar\.gz' } | Select-Object -First 1; `
$targetFile = Join-Path $path $asset.name; `
Invoke-WebRequest $asset.browser_download_url -OutFile $targetFile; `
tar -xzf $targetFile -C $path; `
$extractedDir = Get-ChildItem $path -Directory -Filter "lsd-*-x86_64-unknown-linux-musl"; `
Move-Item (Join-Path $extractedDir.FullName "lsd") (Join-Path $path "lsd-x86_64-unknown-linux-musl") -Force; `
Remove-Item $extractedDir.FullName -Recurse; Remove-Item $targetFile

$path = "$Env:USERPROFILE\Projects\gaming-utils\sync\mirror\batocera\userdata\system\custom\usr\bin"; `
$asset = (Invoke-RestMethod "https://api.github.com/repos/lsd-rs/lsd/releases/latest").assets | `
    Where-Object { $_.name -match 'lsd-.*-aarch64-unknown-linux-musl\.tar\.gz' } | Select-Object -First 1; `
$targetFile = Join-Path $path $asset.name; `
Invoke-WebRequest $asset.browser_download_url -OutFile $targetFile; `
tar -xzf $targetFile -C $path; `
$extractedDir = Get-ChildItem $path -Directory -Filter "lsd-*-aarch64-unknown-linux-musl"; `
Move-Item (Join-Path $extractedDir.FullName "lsd") (Join-Path $path "lsd-aarch64-unknown-linux-musl") -Force; `
Remove-Item $extractedDir.FullName -Recurse; Remove-Item $targetFile

# oh-my-posh
$binDir = "$Env:USERPROFILE\Projects\gaming-utils\sync\mirror\batocera\userdata\system\custom\usr\bin"; `
$poshFiles = @{ `
    "posh-linux-amd64" = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64"; `
    "posh-linux-arm64" = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm64"; }; `
foreach ($fileName in $poshFiles.Keys) { `
    $destination = Join-Path $binDir $fileName; $tempFile = [System.IO.Path]::GetTempFileName(); `
    Invoke-WebRequest -Uri $poshFiles[$fileName] -OutFile $tempFile; `
    if (-not (Test-Path $destination)) { Move-Item $tempFile $destination -Force; } `
    else { `
        $sourceHash = Get-FileHash $tempFile -Algorithm SHA256; $destHash = Get-FileHash $destination -Algorithm SHA256; `
        if ($sourceHash.Hash -ne $destHash.Hash) { Move-Item $tempFile $destination -Force; } `
        else { Remove-Item $tempFile -Force; } } `
}; `
$GitDir = "$Env:USERPROFILE\Projects\gaming-utils\sync\mirror\batocera\userdata\system\.config\oh-my-posh"; If (Test-Path $GitDir) { Set-Location $GitDir; git pull; Set-Location - } Else { git clone "https://github.com/cscribn/dotfiles-oh-my-posh.git" $GitDir}
