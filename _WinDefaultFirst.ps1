# Non-package installations (add/update these first)
# freefilesync
# git-sdk (uninstall once pacman is scriptable)
# winget

. $PSScriptRoot\_WinDefaultRegistry.ps1

winget install -e --id Chocolatey.Chocolatey
choco upgrade chocolatey -y
choco feature enable -n='useRememberedArgumentsForUpgrades'

# pacman
if (-Not (Test-Path "C:\Program Files\Git\usr\bin\pacman.exe") -and (Test-Path "C:\git-sdk-64\usr\bin\pacman.exe")) { `
	Copy-Item "C:\git-sdk-64\usr\bin\pacman.exe" -Destination "C:\Program Files\Git\usr\bin"; `
	Copy-Item "C:\git-sdk-64\etc\pacman.conf" -Destination "C:\Program Files\Git\etc"; `
	Copy-Item -Recurse "C:\git-sdk-64\etc\pacman.d" -Destination "C:\Program Files\Git\etc"; `
	Copy-Item -Recurse "C:\git-sdk-64\var" -Destination "C:\Program Files\Git" `
}; `
& "C:\Program Files\Git\bin\bash.exe" -c -i "pacman -Sy --needed --noconfirm --overwrite \* pacman"

choco upgrade choco-cleaner --params "'/NOTASK:TRUE'" -y --ignore-dependencies; Start-Process -FilePath "C:\ProgramData\chocolatey\bin\choco-cleaner.bat" -Wait
winget install -e --id cURL.cURL
winget install -e --id Git.Git; git config --global http.sslBackend openssl
winget install -e --id=Microsoft.PowerShell; Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted; Install-Module -Name Microsoft.WinGet.Client; Install-Module posh-git; Install-Module PSReadLine; Install-Module Terminal-Icons

winget install -e --id 7zip.7zip
winget install -e --id Mythicsoft.AgentRansack
winget install -e --id Armin2208.WindowsAutoNightMode
winget install -e --id sharkdp.bat
winget install -e --id TGRMNSoftware.BulkRenameUtility

# caffeine and startup shortcut
choco upgrade caffeine -y --ignore-dependencies; `
$Shell = New-Object -comObject WScript.Shell; `
$Shortcut = $Shell.CreateShortcut("$Env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Caffeine.lnk"); `
$Shortcut.TargetPath = "C:\ProgramData\chocolatey\lib\caffeine\caffeine64.exe"; `
$Shortcut.Arguments = "-allowss"; `
$Shortcut.WorkingDirectory = "C:\ProgramData\chocolatey\lib\caffeine"; `
$Shortcut.Save()

winget install -e --id Google.ChromeRemoteDesktopHost
winget install -e --id chrisant996.Clink; cmd.exe /c "`"C:\Program Files (x86)\clink\clink`" update /S";cmd.exe /c "`"C:\Program Files (x86)\clink\clink`" autorun uninstall"
winget install -e --id AcroSoftwareInc.CutePDFWriter
winget install -e --id Spicebrains.Instant-Eyedropper
winget install -e --id Fastfetch-cli.Fastfetch
winget install -e --id Gyan.FFmpeg
choco upgrade filezilla -y --ignore-dependencies
winget install -e --id Mozilla.Firefox
winget install -e --id junegunn.fzf
$Outdated = choco outdated -r; if ($Outdated -match "ghostscript") { choco uninstall ghostscript -f -y }; choco upgrade ghostscript -y --ignore-dependencies
winget install -e --id Google.Chrome
winget install -e --id GIMP.GIMP
winget install -e --id Ridgecrop.guiformat
winget install -e --id HandBrake.HandBrake
winget install -e --id ImageMagick.ImageMagick
winget install -e --id LIGHTNINGUK.ImgBurn
winget install -e --id Inkscape.Inkscape
winget install -e --id IrfanSkiljan.IrfanView
winget install -e --id IrfanSkiljan.IrfanView.PlugIns
winget install -e --id TheDocumentFoundation.LibreOffice.LTS
winget install -e --id DiskInternals.LinuxReader
winget install -e --id lsd-rs.lsd
winget install -e --id FlorianHeidenreich.Mp3tag
winget install -e --id PFOJEnterprisesLLC.ModernCSV
choco upgrade nerd-fonts-meslo -y --ignore-dependencies;robocopy  C:\Windows\Fonts "$Env:USERPROFILE\Fonts Backup" /XO /NFL /NDL /NJH /NC /NS /NP
winget install -e --id Insecure.Nmap
winget install -e --id Notepad++.Notepad++
winget install -e --id gsass1.NTop
winget install -e --id JanDeDobbeleer.OhMyPosh; oh-my-posh disable notice
winget install -e --id Microsoft.OneDrive
winget install -e --id dotPDNLLC.paintdotnet
winget install -e --id PDFLabs.PDFtk.Free
choco upgrade pngquant -y --ignore-dependencies
choco upgrade pngyu -y --ignore-dependencies
winget install -e --id Google.PlatformTools
choco upgrade puretext -y
$Outdated = choco outdated -r; if ($Outdated -match "python") { choco uninstall python -f -y }; choco upgrade python -y --ignore-dependencies; python -m pip install -U pip

# python
# ruby
if ((Get-WinGetPackage -Name Ruby).Count -gt 1) { `
    $Id = (Get-WinGetPackage -Name Ruby).Id | Select-Object -First 1; winget uninstall -e --id $Id `
} `
$Id = (Find-WinGetPackage RubyInstallerTeam.Ruby).Id | Select-Object -Last 1; winget install -e --id $Id

winget install -e --id Scribus.Scribus
choco upgrade sd-card-formatter -y
winget install -e --id RandyRants.SharpKeys
winget install -e --id StrawberryPerl.StrawberryPerl
$Outdated = choco outdated -r; if ($Outdated -match "sumatrapdf") { choco uninstall sumatrapdf -f -y }; choco upgrade sumatrapdf -y --params="'/NoDesktop /WithPreview'" --ignore-dependencies
choco upgrade tftpd32 -y
winget install -e --id VideoLAN.VLC
$Outdated = choco outdated -r; if ($Outdated -match "vim") { choco uninstall vim -f -y }; choco upgrade vim -y --params "'/NoContextmenu /NoDesktopShortcut'"
winget install -e --id Microsoft.VisualStudioCode
winget install -e --id Microsoft.WindowsTerminal
winget install -e --id WiresharkFoundation.Wireshark
winget install -e --id WinMerge.WinMerge
choco upgrade xmlstarlet -y --ignore-dependencies
choco upgrade xmlstarlet.portable -y --ignore-dependencies
winget install -e --id yt-dlg.yt-dlg
winget install -e --id=Zoom.Zoom

# zsh
& "C:\Program Files\Git\bin\bash.exe" -c -i "pacman -Sy --needed --noconfirm --overwrite \* zsh"; `
$GitDir = "$Env:USERPROFILE\.zsh\zsh-autosuggestions"; if (Test-Path $GitDir) { Set-Location $GitDir; & "C:\Program Files\Git\bin\git" pull; Set-Location - } else { & "C:\Program Files\Git\bin\git" clone "https://github.com/zsh-users/zsh-autosuggestions" $GitDir}; `
$GitDir = "$Env:USERPROFILE\.zsh\zsh-syntax-highlighting"; if (Test-Path $GitDir) { Set-Location $GitDir; & "C:\Program Files\Git\bin\git" pull; Set-Location - } else { & "C:\Program Files\Git\bin\git" clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" $GitDir }; `
Get-ChildItem $HOME | Where-Object { $_.Name -match '^\.zsh_history\..+' } | Where-Object LastWriteTime -lt  (Get-Date).AddDays(-5) | Remove-Item

. $PSScriptRoot\_WinDefaultApps.ps1
. $PSScriptRoot\_WinDefaultFileTypes.ps1
