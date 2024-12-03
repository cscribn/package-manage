# Registry
## Explorer - show file extensions
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "HideFileExt", 0)

## Explorer - show hidden files
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden", 1)

## File Associations - prevent photos reset
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppXk0g4vb8gvt7b93tg50ybcy892pge6jmt" –Name "NoOpenWith" -ErrorAction SilentlyContinue; `
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" –Name "NoOpenWith" -ErrorAction SilentlyContinue; `
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppX9rkaq77s0jzh1tyccadx9ghba15r6t3h" –Name "NoOpenWith" -ErrorAction SilentlyContinue

## File Associations - prevent music reset
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" –Name "NoOpenWith" -ErrorAction SilentlyContinue

## File Associations - prevent video reset
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" –Name "NoOpenWith" -ErrorAction SilentlyContinue

## Finish Setting Up - disable suggestions
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement", "ScoobeSystemSettingEnabled", 0)

## Modern Standby - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power", "PlatformAoAcOverride", 0)

## Right-Click - use old
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32", "", "")

## Task Manager - enable
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\4\1887869580", "EnabledState", 2)

## Welcome Experience - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SubscribedContent-310093Enabled", 0)

## Non-registry - disable hibernate and sleep
powercfg -h off
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0

# winget
winget install -e --id cURL.cURL
winget install -e --id Git.Git; git config --global http.sslBackend openssl
winget install -e --id Microsoft.PowerShell; Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted; Install-Module -Name Microsoft.WinGet.Client; Install-Module posh-git; Install-Module PSReadLine
winget install -e --id 7zip.7zip
winget install -e --id Google.Chrome
winget install -e --id IrfanSkiljan.IrfanView -v "4.67"
winget install -e --id IrfanSkiljan.IrfanView.PlugIns -v "4.67"
winget install -e --id Google.PlatformTools
winget install -e --id Valve.Steam
winget install -e --id VideoLAN.VLC
winget install -e --id Microsoft.VisualStudioCode
winget install -e --id Microsoft.WindowsTerminal

# File types
$GitDir = "C:\PS-SFTA"; If (Test-Path $GitDir) { Set-Location $GitDir; & "C:\Program Files\Git\bin\git" pull; Set-Location - } Else { & "C:\Program Files\Git\bin\git" clone "https://github.com/DanysysTeam/PS-SFTA.git" $GitDir }; `
. $GitDir\SFTA.ps1; `
Set-FTA IrfanView.bmp .bmp; `
Set-FTA IrfanView.gif .gif; `
Set-FTA IrfanView.heic .heic; `
Set-FTA IrfanView.jpg .jpeg; `
Set-FTA IrfanView.jpg .jpg; `
Set-FTA IrfanView.png .png; `
Set-FTA IrfanView.tif .tif; `
Set-FTA IrfanView.webp .webp; `
Set-FTA VLC.avi .avi; `
Set-FTA VLC.flac .flac; `
Set-FTA VLC.flv .flv; `
Set-FTA VLC.m4a .m4a; `
Set-FTA VLC.m4v .m4v; `
Set-FTA VLC.mov .mov; `
Set-FTA VLC.mp3 .mp3; `
Set-FTA VLC.mpeg .mpeg; `
Set-FTA VLC.mpg .mpg; `
Set-FTA VLC.rm .rm; `
Set-FTA VLC.swf .swf; `
Set-FTA VLC.wav .wav; `
Set-FTA VLC.wmv .wmv

# Config
## powershell-core
$Line = "Import-Module posh-git; Import-Module PSReadLine; Set-PSReadLineOption -PredictionSource HistoryAndPlugin; Set-PSReadLineOption -EditMode Windows"; `
if (-not (Get-Content $PROFILE -Raw).Contains($Line)) { Add-Content $PROFILE $Line }

