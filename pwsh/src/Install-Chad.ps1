# Non-package installations (add/update these first)
# append C:\jdk to PATH
# backblaze
# github desktop
# iso compressor
# krita generative AI - https://github.com/Acly/krita-ai-diffusion
# mise (first install only from https://github.com/jdx/mise/releases)
# skraperui

[CmdletBinding()]
$Global:InformationPreference = 'Continue'

Import-Module "$PSScriptRoot\Private\WingetUtils.psm1" -Force

Get-Date -Format "dddd, MMMM dd, yyyy - hh:mm tt"

. $PSScriptRoot\Private\Set-Registry.ps1
. $PSScriptRoot\Private\Install-Programs.ps1
. $PSScriptRoot\Private\Install-Apps.ps1

# chocolatey
choco feature enable -n='useRememberedArgumentsForUpgrades'
choco upgrade fluidsynth -y -r -q --ignore-dependencies
choco upgrade gradle -y -r -q --ignore-dependencies
choco upgrade pngquant -y -r -q --ignore-dependencies
choco upgrade pngyu -y -r -q --ignore-dependencies
choco upgrade tftpd32 -y -r -q --ignore-dependencies
choco upgrade win32diskimager --version 0.9.5 -y -r -q --ignore-dependencies; choco pin add --name="'win32diskimager'" --version="'0.9.5'"
choco upgrade xmlstarlet -y -r -q --ignore-dependencies; choco upgrade xmlstarlet.portable -y -r -q --ignore-dependencies
choco upgrade xsltproc -y -r -q --ignore-dependencies

# winget
Install-WinGetPackageClean -Id sharkdp.bat
Install-WinGetPackageClean -Id BlueStack.BlueStacks
Install-WinGetPackageClean -Id DBBrowserForSQLite.DBBrowserForSQLite
Install-WinGetPackageClean -Id Eassos.DiskGenius -InstallType SkipIfInstalled
Install-WinGetPackageClean -Id Deskflow.Deskflow
Install-WinGetPackageClean -Id Docker.DockerDesktop
Install-WinGetPackageClean -Id DVDFlick.DVDFlick
Install-WinGetPackageClean -Id Fastfetch-cli.Fastfetch
Install-WinGetPackageClean -Id Google.GoogleDrive
Install-WinGetPackageClean -Id MHNexus.HxD
Install-WinGetPackageClean -Id NirSoft.IconsExtract
Install-WinGetPackageClean -Id ImageMagick.ImageMagick
if (($Output = Install-WinGetPackageClean -Id EclipseAdoptium.Temurin -Like "*JDK*") -eq $INSTALLED_OR_UPGRADED) {
    $target = Get-ChildItem "C:\Program Files\Eclipse Adoptium" | Sort-Object Name | Select-Object -Last 1
    if ($target) {
        New-Item -ItemType SymbolicLink -Path "C:\jdk" -Target $target.FullName -Force
    }
}
Write-Output $Output
Install-WinGetPackageClean -Id KDE.Krita
Install-WinGetPackageClean -Id GuinpinSoft.MakeMKV
Install-WinGetPackageClean -Id Microsoft.VisualStudio.BuildTools
Install-WinGetPackageClean -Id NextDNS.NextDNS
Install-WinGetPackageClean -Id OpenJS.NodeJS.LTS
Install-WinGetPackageClean -Id Ollama.Ollama -InstallType SkipIfInstalled
Install-WinGetPackageClean -Id Poly.PlantronicsHub
Install-WinGetPackageClean -Id oschwartz10612.Poppler
Install-WinGetPackageClean -Id Postman.Postman
Install-WinGetPackageClean -Id PuTTY.PuTTY
Install-WinGetPackageClean -Id "Python.Python." -InstallType "UnknownId"
Install-WinGetPackageClean -Id RaspberryPiFoundation.RaspberryPiImager
Install-WinGetPackageClean -Id Rufus.Rufus
Install-WinGetPackageClean -Id SBCL.SBCL # steel bank common lisp
Install-WinGetPackageClean -Id srjuddington.slade
Install-WinGetPackageClean -Id SQLite.SQLite
Install-WinGetPackageClean -Id UB-Mannheim.TesseractOCR
Install-WinGetPackageClean -Id astral-sh.uv
Install-WinGetPackageClean -Id Oracle.VirtualBox
Install-WinGetPackageClean -Id WireGuard.WireGuard
Install-WinGetPackageClean -Id MikeFarah.yq

# pipx
pipx upgrade openai-whisper 2>$null || pipx install openai-whisper
pipx upgrade "yt-dlp[default]" 2>$null || pipx install "yt-dlp[default]"

# python
python -m pip install --upgrade pip
python -m pip install --user pipx
python -m pipx ensurepath

# wsl
if (-Not (wsl --list -version)) { wsl --install }
wsl -d "Ubuntu" -u root -e apt update -y
wsl -d "Ubuntu" -u root -e apt install expect -y
wsl -d "Ubuntu" -u root -e apt full-upgrade -y
wsl -d "Ubuntu" -u root -e do-release-upgrade
wsl -d "Ubuntu" -u root -e apt autoremove -y
wsl -d "Ubuntu" -u root -e apt clean -y

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
    git pull origin; Set-Location -
} else {
    git init $GitDir
    Set-Location $GitDir
    git checkout -b main
    git remote add origin "https://github.com/cscribn/dotfiles-misc"
    git sparse-checkout set "requirements"
    git pull --set-upstream origin main
    Set-Location -
}

. $PSScriptRoot\Private\Copy-ProjectsChad.ps1
. $PSScriptRoot\Private\Copy-Config.ps1
. $PSScriptRoot\Private\Remove-Unwanted.ps1
. $PSScriptRoot\Private\Reset-Network.ps1

# cleanup
if (docker info > $null 2>&1) { docker system prune --volumes -f }
