# Non-package installations (add/update these first)
# winget

# remove customized prompt
function prompt {}

. $PSScriptRoot\_WinDefaultRegistryCallan.ps1

# winget
winget install -e --id cURL.cURL

# git
$GitUpdate = winget upgrade -e --id Git.Git; `
if (-Not ($GitUpdate -match "No available")) { `
    winget uninstall -e --id Git.Git; `
    winget install -e --id Git.Git; git config --global http.sslBackend openssl `
}

# powershell
if (winget install -e --id Microsoft.PowerShell | Select-String "technology is different") { `
winget uninstall -e --id Microsoft.PowerShell; winget install -e --id Microsoft.PowerShell };

winget install -e --id 7zip.7zip
winget install -e --id dotPDN.PaintDotNet

# google chrome
if ((Get-WinGetPackage -Name "Google Chrome").Count -eq 0) { `
	winget install -e --id Google.Chrome `
}

winget install -e --id Google.ChromeRemoteDesktopHost
winget install -e --id Google.PlatformTools
winget install -e --id REALiX.HWiNFO
winget install -e --id IrfanSkiljan.IrfanView
winget install -e --id IrfanSkiljan.IrfanView.PlugIns
winget install -e --id LIGHTNINGUK.ImgBurn

# microsoft edge
if ((Get-WinGetPackage -Id "Microsoft.Edge").Count -eq 0) { `
	winget install -e --id Microsoft.Edge `
}

winget install -e --id Microsoft.WindowsTerminal
winget install -e --id Mozilla.Firefox
winget install -e --id SumatraPDF.SumatraPDF
winget install -e --id TheDocumentFoundation.LibreOffice
winget install -e --id VideoLAN.VLC
winget install -e --id Microsoft.WindowsPCHealthCheck
winget install -e --id Zoom.Zoom

. $PSScriptRoot\_WinDefaultApps.ps1
. $PSScriptRoot\_WinDefaultFileTypesCallan.ps1
