[CmdletBinding()]
$Global:InformationPreference = 'Continue'

Get-Date -Format "dddd, MMMM dd, yyyy - hh:mm tt"

. $PSScriptRoot\Private\Set-Registry.ps1
. $PSScriptRoot\Private\Install-Programs-Elevated.ps1
. $PSScriptRoot\Private\Install-Apps-Elevated.ps1

# chocolatey
choco feature enable -n='useRememberedArgumentsForUpgrades'
choco upgrade fluidsynth -y -r -q --ignore-dependencies
choco upgrade gradle -y -r -q --ignore-dependencies
choco upgrade pngquant -y -r -q --ignore-dependencies
choco upgrade pngyu -y -r -q --ignore-dependencies
choco upgrade tftpd32 -y -r -q --ignore-dependencies
choco upgrade win32diskimager --version 0.9.5 -y -r -q --ignore-dependencies; choco pin add --name='"win32diskimager"' --version='"0.9.5"'
choco upgrade xmlstarlet -y -r -q --ignore-dependencies; choco upgrade xmlstarlet.portable -y -r -q --ignore-dependencies
choco upgrade xsltproc -y -r -q --ignore-dependencies

# pipx
pipx upgrade ipython -q 2>$null || pipx install ipython -q
pipx upgrade openai-whisper -q 2>$null || pipx install openai-whisper -q
pipx upgrade "yt-dlp[default]" -q 2>$null || pipx install "yt-dlp[default]" -q

# python
python -m pip install --upgrade pip -q
python -m pip install --user pipx -q
python -m pipx ensurepath

# wsl
if (-Not (wsl --list -version)) { wsl --install }
wsl -d "Ubuntu" -u root -e apt-get -q update -y
wsl -d "Ubuntu" -u root -e apt-get -q install expect -y
wsl -d "Ubuntu" -u root -e apt-get -q full-upgrade -y
wsl -d "Ubuntu" -u root -e do-release-upgrade
wsl -d "Ubuntu" -u root -e apt-get -q autoremove -y
wsl -d "Ubuntu" -u root -e apt-get clean -y

# config
## git
git config --global diff.word.textconv pandoc --to=markdown

## copilot instructions
New-Item -ItemType Directory -Force -Path "$Env:USERPROFILE\.copilot"
curl -sSLo "$Env:USERPROFILE\.copilot\copilot-instructions.md" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/github/copilot-instructions.md

## microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"
curl -sSLo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-chad.json

# requirements
$GitDir = "$Env:USERPROFILE\.config\dotfiles-misc"
if (Test-Path $GitDir) {
    Set-Location $GitDir
    git pull -q origin; Set-Location -
} else {
    git init -q $GitDir
    Set-Location $GitDir
    git checkout -q -b main
    git remote add origin "https://github.com/cscribn/dotfiles-misc"
    git sparse-checkout set "requirements"
    git pull -q --set-upstream origin main
    Set-Location -
}

. $PSScriptRoot\Private\Copy-ProjectsChad.ps1
. $PSScriptRoot\Private\Copy-Config.ps1
. $PSScriptRoot\Private\Remove-Unwanted.ps1
. $PSScriptRoot\Private\Reset-Network.ps1

# cleanup
if (docker info > $null 2>&1) { docker system prune --volumes -f -q }
