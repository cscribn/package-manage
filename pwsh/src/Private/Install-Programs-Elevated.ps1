[CmdletBinding()]
$Global:InformationPreference = 'Continue'

# chocolatey
choco upgrade chocolatey -y -r -q
choco feature enable -n='useRememberedArgumentsForUpgrades'
choco upgrade chocolatey-font-helpers.extension -y -r -q --ignore-dependencies
choco upgrade filezilla -y -r -q --ignore-dependencies
choco upgrade nerd-fonts-meslo -y -r -q --ignore-dependencies

# fonts backup
$FontBackupPath = Join-Path $Env:USERPROFILE 'Fonts Backup'
$summary = robocopy C:\Windows\Fonts $FontBackupPath /XO /R:0 /W:0 |
    Select-String '^[ \t]*Files\s*:' | Select-Object -Last 1
if ($summary -and $summary.Line -match 'Files\s*:\s*\d+\s+(\d+)\s+(\d+)\s+\d+\s+(\d+)') {
    "Fonts Backup Finished — Copied: $($Matches[1]), Skipped: $($Matches[2]), Failed: $($Matches[3])"
} else {
    Write-Output "ERROR: Unable to parse robocopy summary line: '$($summary?.Line)'"
}

# pacman
if (-Not (Test-Path "C:\Program Files\Git\usr\bin\pacman.exe") -and (Test-Path "C:\git-sdk-64\usr\bin\pacman.exe")) {
    Copy-Item "C:\git-sdk-64\usr\bin\pacman.exe" -Destination "C:\Program Files\Git\usr\bin"
    Copy-Item "C:\git-sdk-64\etc\pacman.conf" -Destination "C:\Program Files\Git\etc"
    Copy-Item -Recurse "C:\git-sdk-64\etc\pacman.d" -Destination "C:\Program Files\Git\etc"
    Copy-Item -Recurse "C:\git-sdk-64\var" -Destination "C:\Program Files\Git"
}
& "C:\Program Files\Git\bin\bash.exe" -c -i "pacman -S -q --needed --noconfirm --overwrite \* pacman"

# powershell modules
Update-Module -Name Microsoft.WinGet.Client
Update-Module -Name posh-git
Update-Module -Name PSReadLine
Update-Module -Name Terminal-Icons

# zsh
& "C:\Program Files\Git\bin\bash.exe" -c -i "pacman -S -q --needed --noconfirm --overwrite \* zsh"
$GitDir = "$Env:USERPROFILE\.zsh\zsh-autosuggestions"
if (Test-Path $GitDir) {
    Set-Location $GitDir
    git pull -q; Set-Location -
} else {
    git clone -q "https://github.com/zsh-users/zsh-autosuggestions" $GitDir
}
$GitDir = "$Env:USERPROFILE\.zsh\zsh-syntax-highlighting"
if (Test-Path $GitDir) {
    Set-Location $GitDir
    git pull -q; Set-Location -
} else {
    git clone -q "https://github.com/zsh-users/zsh-syntax-highlighting.git" $GitDir
}
Get-ChildItem $HOME | Where-Object { $_.Name -match '^\.zsh_history\..+' } | Where-Object LastWriteTime -lt  (Get-Date).AddDays(-5) | Remove-Item
