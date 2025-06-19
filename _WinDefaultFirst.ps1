# Non-package installations (add/update these first)
# freefilesync
# git-sdk (uninstall once pacman is scriptable)
# winget

# remove customized prompt
function prompt {}

. $PSScriptRoot\_WinDefaultRegistry.ps1

# chocolatey
choco upgrade chocolatey -y
choco feature enable -n='useRememberedArgumentsForUpgrades'
choco upgrade chocolatey-font-helpers.extension -y --ignore-dependencies
choco upgrade nerd-fonts-meslo -y --ignore-dependencies; robocopy  C:\Windows\Fonts "$Env:USERPROFILE\Fonts Backup" /XO /NFL /NDL /NJH /NC /NS /NP
choco upgrade filezilla -y --ignore-dependencies

# pacman
if (-Not (Test-Path "C:\Program Files\Git\usr\bin\pacman.exe") -and (Test-Path "C:\git-sdk-64\usr\bin\pacman.exe")) { `
	Copy-Item "C:\git-sdk-64\usr\bin\pacman.exe" -Destination "C:\Program Files\Git\usr\bin"; `
	Copy-Item "C:\git-sdk-64\etc\pacman.conf" -Destination "C:\Program Files\Git\etc"; `
	Copy-Item -Recurse "C:\git-sdk-64\etc\pacman.d" -Destination "C:\Program Files\Git\etc"; `
	Copy-Item -Recurse "C:\git-sdk-64\var" -Destination "C:\Program Files\Git" `
}; `
& "C:\Program Files\Git\bin\bash.exe" -c -i "pacman -S --needed --noconfirm --overwrite \* pacman"

# winget
winget install -e --id cURL.cURL
winget install -e --id Git.Git; git config --global http.sslBackend openssl

## powershell
winget install -e --id Microsoft.PowerShell; Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted; `
Start-Process pwsh -ArgumentList { Install-Module -Name Microsoft.WinGet.Client -Force } -WindowStyle Hidden -Wait; `
Start-Process pwsh -ArgumentList { Install-Module posh-git -Force } -WindowStyle Hidden -Wait; `
Start-Process pwsh -ArgumentList { Install-Module PSReadLine -Force } -WindowStyle Hidden -Wait; `
Start-Process pwsh -ArgumentList { Install-Module Terminal-Icons } -WindowStyle Hidden -Wait

winget install -e --id 7zip.7zip
winget install -e --id aristocratos.btop4win
winget install -e --id Armin2208.WindowsAutoNightMode
winget install -e --id chrisant996.Clink; cmd.exe /c "`"C:\Program Files (x86)\clink\clink`" update /S";cmd.exe /c "`"C:\Program Files (x86)\clink\clink`" autorun uninstall"
winget install -e --id DiskInternals.LinuxReader
winget install -e --id dotPDN.PaintDotNet

# mp3tag with right-click support
winget install -e --id FlorianHeidenreich.Mp3tag && `
regsvr32 /s "C:\Program Files\Mp3tag\Mp3tagShell.dll"

# gimp
if ((Get-WinGetPackage -Name GIMP).Count -gt 1) { `
    $Id = Get-WinGetPackage -Name GIMP | Sort-Object Id | Select-Object -ExpandProperty Id | Select-Object -First 1; winget uninstall -e --id $Id `
} `
$Id = Find-WinGetPackage GIMP.GIMP | Where-Object { $_.Version -match '^\d+(\.\d+)*$' } | Sort-Object -Property { [version]$_.Version } | Select-Object -Last 1 -ExpandProperty Id; winget install -e --id $Id;

# google chrome
if ((Get-WinGetPackage -Name "Google Chrome").Count -eq 0) { `
	winget install -e --id Google.Chrome `
}

winget install -e --id Google.ChromeRemoteDesktopHost
winget install -e --id Google.PlatformTools
winget install -e --id gsass1.NTop
winget install -e --id Gyan.FFmpeg
winget install -e --id HandBrake.HandBrake
winget install -e --id Inkscape.Inkscape
winget install -e --id Insecure.Nmap
winget install -e --id IrfanSkiljan.IrfanView
winget install -e --id IrfanSkiljan.IrfanView.PlugIns
winget install -e --id JanDeDobbeleer.OhMyPosh; oh-my-posh disable notice
winget install -e --id junegunn.fzf
winget install -e --id LIGHTNINGUK.ImgBurn
winget install -e --id lsd-rs.lsd

# microsoft edge
if ((Get-WinGetPackage -Id "Microsoft.Edge").Count -eq 0) { `
	winget install -e --id Microsoft.Edge `
}

# microsoft visual studio code
if ((Get-WinGetPackage -Name "Microsoft Visual Studio Code").Count -eq 0) { `
	winget install -e --id Microsoft.VisualStudioCode `
}

winget install -e --id Microsoft.WindowsTerminal
winget install -e --id Mozilla.Firefox
winget install -e --id Mythicsoft.AgentRansack
winget install -e --id Notepad++.Notepad++
winget install -e --id PDFLabs.PDFtk.Free
winget install -e --id PFOJEnterprisesLLC.ModernCSV
winget install -e --id RandyRants.SharpKeys
winget install -e --id Scribus.Scribus

winget install -e --id SumatraPDF.SumatraPDF
winget install -e --id TGRMNSoftware.BulkRenameUtility
winget install -e --id TheDocumentFoundation.LibreOffice
winget install -e --id VideoLAN.VLC
winget install -e --id WinMerge.WinMerge
winget install -e --id WiresharkFoundation.Wireshark
winget install -e --id yt-dlg.yt-dlg
winget install -e --id Zoom.Zoom

# zsh
& "C:\Program Files\Git\bin\bash.exe" -c -i "pacman -S --needed --noconfirm --overwrite \* zsh"; `
$GitDir = "$Env:USERPROFILE\.zsh\zsh-autosuggestions"; if (Test-Path $GitDir) { Set-Location $GitDir; & "C:\Program Files\Git\bin\git" pull; Set-Location - } else { & "C:\Program Files\Git\bin\git" clone "https://github.com/zsh-users/zsh-autosuggestions" $GitDir}; `
$GitDir = "$Env:USERPROFILE\.zsh\zsh-syntax-highlighting"; if (Test-Path $GitDir) { Set-Location $GitDir; & "C:\Program Files\Git\bin\git" pull; Set-Location - } else { & "C:\Program Files\Git\bin\git" clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" $GitDir }; `
Get-ChildItem $HOME | Where-Object { $_.Name -match '^\.zsh_history\..+' } | Where-Object LastWriteTime -lt  (Get-Date).AddDays(-5) | Remove-Item

. $PSScriptRoot\_WinDefaultApps.ps1
. $PSScriptRoot\_WinDefaultFileTypes.ps1
