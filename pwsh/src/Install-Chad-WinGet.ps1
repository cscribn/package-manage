[CmdletBinding()]
$Global:InformationPreference = 'Continue'

Import-Module "$PSScriptRoot\Private\WingetUtils.psm1" -Force

Get-Date -Format "dddd, MMMM dd, yyyy - hh:mm tt"

. $PSScriptRoot\Private\Install-Programs-WinGet.ps1
. $PSScriptRoot\Private\Install-Apps-WinGet.ps1

# winget
Install-WinGetPackageClean -Id sharkdp.bat
Install-WinGetPackageClean -Id BlueStack.BlueStacks
Install-WinGetPackageClean -Id DBBrowserForSQLite.DBBrowserForSQLite
Install-WinGetPackageClean -Id Eassos.DiskGenius -InstallType "SkipIfInstalled"
Install-WinGetPackageClean -Id Deskflow.Deskflow
Install-WinGetPackageClean -Id Docker.DockerDesktop
Install-WinGetPackageClean -Id DVDFlick.DVDFlick
Install-WinGetPackageClean -Id Fastfetch-cli.Fastfetch
Install-WinGetPackageClean -Id Google.GoogleDrive
Install-WinGetPackageClean -Id MHNexus.HxD
Install-WinGetPackageClean -Id NirSoft.IconsExtract
Install-WinGetPackageClean -Id ImageMagick.ImageMagick
Install-WinGetPackageClean -Id EclipseAdoptium.Temurin -Like "*JDK*"
Install-WinGetPackageClean -Id KDE.Krita
Install-WinGetPackageClean -Id GuinpinSoft.MakeMKV
Install-WinGetPackageClean -Id Microsoft.VisualStudio.BuildTools
Install-WinGetPackageClean -Id NextDNS.NextDNS
Install-WinGetPackageClean -Id OpenJS.NodeJS.LTS
Install-WinGetPackageClean -Id Ollama.Ollama -InstallType "SkipIfInstalled"
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
