# Non-package installations (add/update these first)
# chocolatey itself
# freefilesync
# git-sdk (uninstall once pacman is scriptable)
# microsoft-windows-terminal
# winget
#
# Note: --ignore-dependencies is being used on all packages requiring microsoft-vclibs-140-00

. $PSScriptRoot\_WinDefaultRegistry.ps1

choco upgrade chocolatey -y
choco feature enable -n='useRememberedArgumentsForUpgrades'
choco upgrade microsoft-ui-xaml-2-7 -y

# pacman
if (-Not (Test-Path "C:\Program Files\Git\usr\bin\pacman.exe") -and (Test-Path "C:\git-sdk-64\usr\bin\pacman.exe")) { `
	Copy-Item "C:\git-sdk-64\usr\bin\pacman.exe" -Destination "C:\Program Files\Git\usr\bin"; `
	Copy-Item "C:\git-sdk-64\etc\pacman.conf" -Destination "C:\Program Files\Git\etc"; `
	Copy-Item -Recurse "C:\git-sdk-64\etc\pacman.d" -Destination "C:\Program Files\Git\etc"; `
	Copy-Item -Recurse "C:\git-sdk-64\var" -Destination "C:\Program Files\Git" `
}; `
& "C:\Program Files\Git\bin\bash.exe" -c -i "pacman -S --noconfirm pacman"

choco upgrade choco-cleaner --params "'/NOTASK:TRUE'" -y --ignore-dependencies; Start-Process -FilePath "C:\ProgramData\chocolatey\bin\choco-cleaner.bat" -Wait
choco upgrade curl -y
winget install -e  --uninstall-previous --id Git.Git; git config --global http.sslBackend openssl

winget install -e --uninstall-previous --id 7zip.7zip
choco upgrade adb -y
choco upgrade agentransack -y
choco upgrade auto-dark-mode -y
choco upgrade bat -y --ignore-dependencies
choco upgrade bulkrenameutility -y --ignore-checksums -y

# caffeine and startup shortcut
choco upgrade caffeine -y --ignore-dependencies; `
$Shell = New-Object -comObject WScript.Shell; `
$Shortcut = $Shell.CreateShortcut("$Env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Caffeine.lnk"); `
$Shortcut.TargetPath = "C:\ProgramData\chocolatey\lib\caffeine\caffeine64.exe"; `
$Shortcut.Arguments = "-allowss"; `
$Shortcut.WorkingDirectory = "C:\ProgramData\chocolatey\lib\caffeine"; `
$Shortcut.Save()

winget install -e  --uninstall-previous --id Google.ChromeRemoteDesktopHost
choco upgrade clink-maintained -y; cmd.exe /c "`"C:\Program Files (x86)\clink\clink`" update /S";cmd.exe /c "`"C:\Program Files (x86)\clink\clink`" autorun uninstall"
choco upgrade cutepdf -y --ignore-dependencies
choco upgrade instanteyedropper.app -y --ignore-checksums -y
winget install  --uninstall-previous fastfetch
choco upgrade ffmpeg -y
choco upgrade filezilla -y
winget install -e  --uninstall-previous --id Mozilla.Firefox
choco upgrade fzf -y
$Outdated = choco outdated -r; if ($Outdated -match "ghostscript") { choco uninstall ghostscript -f -y }; choco upgrade ghostscript -y --ignore-dependencies
winget install -e  --uninstall-previous --id Google.Chrome
choco upgrade gimp -y
choco upgrade guiformat -y
winget install -e --uninstall-previous --id HandBrake.HandBrake
winget install -e --uninstall-previous --id ImageMagick.ImageMagick
choco upgrade imgburn -y
winget install -e --uninstall-previous --id Inkscape.Inkscape
winget install -e --uninstall-previous --id IrfanSkiljan.IrfanView
winget install -e --uninstall-previous --id IrfanSkiljan.IrfanView.PlugIns
winget install -e --uninstall-previous --id TheDocumentFoundation.LibreOffice.LTS
choco upgrade linux-reader -y
choco upgrade lsd -y --ignore-dependencies
choco upgrade mp3tag -y
choco upgrade moderncsv -y
choco upgrade nerd-fonts-meslo -y --ignore-dependencies;robocopy  C:\Windows\Fonts "$Env:USERPROFILE\Fonts Backup" /XO
choco upgrade nmap -y --ignore-dependencies
winget install -e --uninstall-previous --id Notepad++.Notepad++
choco upgrade ntop.portable -y
choco upgrade oh-my-posh -y; oh-my-posh disable notice
winget install -e --uninstall-previous --id Microsoft.OneDrive
winget install -e --uninstall-previous --id dotPDNLLC.paintdotnet
choco upgrade pdftk -y
choco upgrade pngquant -y
choco upgrade pngyu -y
choco upgrade powershell-core -y --ignore-dependencies; Install-Module posh-git -Force; Install-Module PSReadLine -AllowPrerelease -Force; Install-Module -Name Terminal-Icons -Repository PSGallery -Force

choco upgrade puretext -y
$Outdated = choco outdated -r; if ($Outdated -match "python") { choco uninstall python -f -y }; choco upgrade python -y --ignore-dependencies; python -m pip install -U pip

# ruby
$Count = 0; `
$List = winget list -q Ruby; `
$Array =($List -split '\n'); `
for ($I = 0; $I -lt $Array.Length; $I++) { `
    if ($Array[$I].StartsWith("Ruby")) { `
        $Count++; `
        if ($Count -gt 1) { winget uninstall $OldRuby[2]; Break }; `
        $OldRuby = $Array[$I] -split ' '; `
    } `
}; `
$Search = winget search RubyInstallerTeam.Ruby | Select-Object -Last 1; $Split = $Search -split ' '; $Ver = $Split[0] + "." + $Split[1]; winget install -e --uninstall-previous --id RubyInstallerTeam.$Ver

$Outdated = choco outdated -r; if ($Outdated -match "scribus") { choco uninstall scribus -f -y }; choco upgrade scribus -i -y
choco upgrade sd-card-formatter -y
choco upgrade sharpkeys -y
winget install -e --uninstall-previous --id StrawberryPerl.StrawberryPerl
$Outdated = choco outdated -r; if ($Outdated -match "sumatrapdf") { choco uninstall sumatrapdf -f -y }; choco upgrade sumatrapdf -y --params="'/NoDesktop /WithPreview'" --ignore-dependencies
choco upgrade tftpd32 -y
winget install -e --uninstall-previous --id VideoLAN.VLC
$Outdated = choco outdated -r; if ($Outdated -match "vim") { choco uninstall vim -f -y }; choco upgrade vim -y --params "'/NoContextmenu /NoDesktopShortcut'"
winget install -e --uninstall-previous --id WiresharkFoundation.Wireshark
choco upgrade winmerge -y
choco upgrade xmlstarlet -y --ignore-dependencies
choco upgrade xmlstarlet.portable -y --ignore-dependencies
winget install -e --uninstall-previous --id yt-dlg.yt-dlg
choco upgrade zoom -y

# zsh
& "C:\Program Files\Git\bin\bash.exe" -c -i "pacman -S --needed --noconfirm --overwrite \* zsh"; `
$GitDir = "$Env:USERPROFILE\.zsh\zsh-autosuggestions"; if (Test-Path $GitDir) { Set-Location $GitDir; & "C:\Program Files\Git\bin\git" pull; Set-Location - } else { & "C:\Program Files\Git\bin\git" clone "https://github.com/zsh-users/zsh-autosuggestions" $GitDir}; `
$GitDir = "$Env:USERPROFILE\.zsh\zsh-syntax-highlighting"; if (Test-Path $GitDir) { Set-Location $GitDir; & "C:\Program Files\Git\bin\git" pull; Set-Location - } else { & "C:\Program Files\Git\bin\git" clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" $GitDir }; `
Get-ChildItem $HOME | Where-Object { $_.Name -match '^\.zsh_history\..+' } | Where-Object LastWriteTime -lt  (Get-Date).AddDays(-5) | Remove-Item

. $PSScriptRoot\_WinDefaultApps.ps1
. $PSScriptRoot\_WinDefaultFileTypes.ps1
