# Non-package installations (add/update these first)
# chocolatey itself
# freefilesync
# git-sdk (uninstall once pacman is scriptable)
# microsoft-windows-terminal

. $PSScriptRoot\_WinDefaultRegistry.ps1

choco upgrade chocolatey -y
choco upgrade winget -y

# pacman
if (-Not (Test-Path "C:\Program Files\Git\usr\bin\pacman.exe") -and (Test-Path "C:\git-sdk-64\usr\bin\pacman.exe")) { `
	Copy-Item "C:\git-sdk-64\usr\bin\pacman.exe" -Destination "C:\Program Files\Git\usr\bin"; `
	Copy-Item "C:\git-sdk-64\etc\pacman.conf" -Destination "C:\Program Files\Git\etc"; `
	Copy-Item -Recurse "C:\git-sdk-64\etc\pacman.d" -Destination "C:\Program Files\Git\etc"; `
	Copy-Item -Recurse "C:\git-sdk-64\var" -Destination "C:\Program Files\Git" `
}; `
& "C:\Program Files\Git\bin\bash.exe" -c -i "pacman -S --noconfirm pacman"

choco upgrade choco-cleaner --params "'/NOTASK:TRUE'" -y; Start-Process -FilePath "C:\ProgramData\chocolatey\bin\choco-cleaner.bat" -Wait
choco upgrade curl -y
choco uninstall git -y
choco upgrade git --params "'/NoShellIntegration'" -y; git config --global http.sslBackend openssl

choco upgrade 7zip -y
choco upgrade adb -y
choco upgrade agentransack -y
choco upgrade auto-dark-mode -y
choco upgrade bat -y
choco upgrade bulkrenameutility -y --ignore-checksums -y

# caffeine and startup shortcut
choco upgrade caffeine -y; `
$Shell = New-Object -comObject WScript.Shell; `
$Shortcut = $Shell.CreateShortcut("$Env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Caffeine.lnk"); `
$Shortcut.TargetPath = "C:\ProgramData\chocolatey\lib\caffeine\caffeine64.exe"; `
$Shortcut.Arguments = "-allowss"; `
$Shortcut.WorkingDirectory = "C:\ProgramData\chocolatey\lib\caffeine"; `
$Shortcut.Save()

winget install -e --id Google.ChromeRemoteDesktopHost
choco upgrade clink-maintained -y; cmd.exe /c "`"C:\Program Files (x86)\clink\clink`" update /S";cmd.exe /c "`"C:\Program Files (x86)\clink\clink`" autorun uninstall"
choco upgrade cutepdf -y
choco upgrade instanteyedropper.app -y --ignore-checksums -y
winget install fastfetch
choco upgrade ffmpeg -y
choco upgrade filezilla -y
choco upgrade firefox -y --params "'/NoTaskbarShortcut /NoDesktopShortcut'"
$Outdated = choco outdated -r; if ($Outdated -match "ghostscript") { choco uninstall ghostscript -f -y }; choco upgrade ghostscript -y
winget install -e --id Google.Chrome
choco upgrade gimp -y
choco upgrade guiformat -y
choco upgrade handbrake -y
winget install -e --id ImageMagick.ImageMagick
choco upgrade imgburn -y
choco upgrade inkscape -y
choco upgrade irfanview -y
choco upgrade irfanviewplugins -y
choco upgrade libreoffice-still -y
choco upgrade linux-reader -y
choco upgrade lsd -y
choco upgrade mp3tag -y
choco upgrade nerd-fonts-meslo -y;robocopy  C:\Windows\Fonts "$Env:USERPROFILE\Fonts Backup" /XO
choco upgrade nmap -y
winget install -e --id Notepad++.Notepad++
choco upgrade ntop.portable -y

# nvm, node, and removing old node versions
choco upgrade nvm -y; nvm install lts; nvm use lts; `
Set-Location "$Env:PROGRAMDATA\nvm"; $Nodes = Get-ChildItem -Directory | Sort-Object Name; $NodeCount = 0; `
foreach ($Node in $Nodes) { $NodeCount++; if ($NodeCount -lt $Nodes.Length - 1) { nvm uninstall $Node.Name } }; Set-Location -

choco upgrade oh-my-posh -y; oh-my-posh disable notice
choco upgrade onedrive --ignore-checksums -y
choco upgrade paint.net -y
choco upgrade pdftk -y
choco upgrade pngquant -y
choco upgrade pngyu -y
choco upgrade powershell-core -y; Install-Module posh-git -Force; Install-Module PSReadLine -AllowPrerelease -Force; Install-Module -Name Terminal-Icons -Repository PSGallery -Force

choco upgrade puretext -y
$Outdated = choco outdated -r; if ($Outdated -match "python") { choco uninstall python -f -y }; choco upgrade python -y; python -m pip install -U pip

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
$Search = winget search RubyInstallerTeam.Ruby | Select-Object -Last 1; $Split = $Search -split ' '; $Ver = $Split[0] + "." + $Split[1]; winget install --uninstall-previous -e --id RubyInstallerTeam.$Ver

$Outdated = choco outdated -r; if ($Outdated -match "scribus") { choco uninstall scribus -f -y }; choco upgrade scribus -i -y
choco upgrade sd-card-formatter -y
choco upgrade sharpkeys -y
choco upgrade strawberryperl -y
choco upgrade sumatrapdf -y
choco upgrade tftpd32 -y
choco upgrade vlc -y
$Outdated = choco outdated -r; if ($Outdated -match "vim") { choco uninstall vim -f -y }; choco upgrade vim -y --params "'/NoContextmenu /NoDesktopShortcut'"
winget install -e --id WiresharkFoundation.Wireshark
choco upgrade winmerge -y
choco upgrade xmlstarlet -y
winget install -e --id yt-dlg.yt-dlg
choco upgrade zoom -y

# zsh
& "C:\Program Files\Git\bin\bash.exe" -c -i "pacman -S --needed --noconfirm --overwrite \* zsh"; `
$GitDir = "$Env:USERPROFILE\.zsh\zsh-autosuggestions"; if (Test-Path $GitDir) { Set-Location $GitDir; & "C:\Program Files\Git\bin\git" pull; Set-Location - } else { & "C:\Program Files\Git\bin\git" clone "https://github.com/zsh-users/zsh-autosuggestions" $GitDir}; `
$GitDir = "$Env:USERPROFILE\.zsh\zsh-syntax-highlighting"; if (Test-Path $GitDir) { Set-Location $GitDir; & "C:\Program Files\Git\bin\git" pull; Set-Location - } else { & "C:\Program Files\Git\bin\git" clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" $GitDir }; `
Get-ChildItem $HOME | Where-Object { $_.Name -match '^\.zsh_history\..+' } | Where-Object LastWriteTime -lt  (Get-Date).AddDays(-5) | Remove-Item

. $PSScriptRoot\_WinDefaultApps.ps1
. $PSScriptRoot\_WinDefaultFileTypes.ps1
