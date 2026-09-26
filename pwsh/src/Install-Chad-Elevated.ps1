# Non-package installations (add/update these first)
# append C:\jdk to PATH
# backblaze
# github desktop
# grill-me skill
# iso compressor
# krita generative AI - https://github.com/Acly/krita-ai-diffusion
# mise (first install only from https://github.com/jdx/mise/releases)
# skraperui

[CmdletBinding()]
$Global:InformationPreference = 'Continue'

Get-Date -Format "dddd, MMMM dd, yyyy - hh:mm tt"

. $PSScriptRoot\Private\Set-Registry.ps1
. $PSScriptRoot\Private\Install-Programs-Elevated.ps1
. $PSScriptRoot\Private\Install-Apps-Elevated.ps1
. $PSScriptRoot\Private\Install-Helpers.ps1

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

# npx
## skills
Set-Location "$Env:USERPROFILE\Projects\dotfiles-misc"
npx --silent -y skills@latest update --yes
Set-Location -

# python
python -m pip install --upgrade pip -q
python -m pip install --user pipx -q
python -m pipx ensurepath

# pipx packages
if (-not (Ensure-PipxPackage -Package 'ipython')) { exit 1 }
if (-not (Ensure-PipxPackage -Package 'openai-whisper')) { exit 1 }
if (-not (Ensure-PipxPackage -Package 'yt-dlp[default]')) { exit 1 }

# wsl
if (-Not (wsl --list -version)) { wsl --install }
$EnvFlags = "DEBIAN_FRONTEND=noninteractive"
$AptFlags = "-qq -y -o=Dpkg::Use-Pty=0"
wsl -d "Ubuntu" -u root -e bash -c "export $EnvFlags; apt-get update $AptFlags"
wsl -d "Ubuntu" -u root -e bash -c "export $EnvFlags; apt-get install expect $AptFlags"
wsl -d "Ubuntu" -u root -e bash -c "export $EnvFlags; apt-get full-upgrade $AptFlags"
wsl -d "Ubuntu" -u root -e bash -c "export $EnvFlags; do-release-upgrade"
wsl -d "Ubuntu" -u root -e bash -c "export $EnvFlags; apt-get autoremove $AptFlags"
wsl -d "Ubuntu" -u root -e bash -c "export $EnvFlags; apt-get clean $AptFlags"

# config
## git
git config --global diff.word.textconv pandoc --to=markdown

## agent instructions
New-Item -ItemType Directory -Force -Path "$Env:USERPROFILE\ai"
curl -sSLo "$Env:USERPROFILE\ai\AGENTS.md" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/ai/AGENTS.md

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
