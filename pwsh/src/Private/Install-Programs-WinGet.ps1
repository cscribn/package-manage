[CmdletBinding()]
$Global:InformationPreference = 'Continue'

Import-Module "$PSScriptRoot\WingetUtils.psm1" -Force

# remove customized prompt
function prompt {}

# winget
Install-WinGetPackageClean -Id cURL.cURL
if (($Output = Install-WinGetPackageClean -Id Git.Git) -eq $INSTALLED_OR_UPGRADED) {
    git config --global http.sslBackend openssl
}
Write-Output $Output
Install-WinGetPackageClean -Id 7zip.7zip
Install-WinGetPackageClean -Id Mythicsoft.AgentRansack
Install-WinGetPackageClean -Id ArminOsaj.AutoDarkMode
Install-WinGetPackageClean -Id aristocratos.btop4win
Install-WinGetPackageClean -Id TGRMNSoftware.BulkRenameUtility
if (($Output = Install-WinGetPackageClean -Id chrisant996.Clink) -eq $INSTALLED_OR_UPGRADED) {
    cmd.exe /c "`"C:\Program Files (x86)\clink\clink`" update /S"; cmd.exe /c "`"C:\Program Files (x86)\clink\clink`" autorun uninstall"
}
Write-Output $Output
Install-WinGetPackageClean -Id Gyan.FFmpeg
Install-WinGetPackageClean -Id Mozilla.Firefox
Install-WinGetPackageClean -Id junegunn.fzf
Install-WinGetPackageClean -Id GIMP.GIMP
Install-WinGetPackageClean -Id Google.Chrome -InstallType "SkipIfInstalled"
Install-WinGetPackageClean -Id Google.ChromeRemoteDesktopHost
Install-WinGetPackageClean -Id Google.PlatformTools
Install-WinGetPackageClean -Id HandBrake.HandBrake
Install-WinGetPackageClean -Id REALiX.HWiNFO
Install-WinGetPackageClean -Id LIGHTNINGUK.ImgBurn
Install-WinGetPackageClean -Id Inkscape.Inkscape
Install-WinGetPackageClean -Id IrfanSkiljan.IrfanView
Install-WinGetPackageClean -Id IrfanSkiljan.IrfanView.PlugIns
Install-WinGetPackageClean -Id jqlang.jq
Install-WinGetPackageClean -Id KDE.KMahjongg
Install-WinGetPackageClean -Id TheDocumentFoundation.LibreOffice
Install-WinGetPackageClean -Id DiskInternals.LinuxReader
Install-WinGetPackageClean -Id lsd-rs.lsd
Install-WinGetPackageClean -Id Microsoft.Edge -InstallType "SkipIfInstalled"
Install-WinGetPackageClean -Id Microsoft.PowerShell -InstallType "UpgradeOnly"
Install-WinGetPackageClean -Id Microsoft.Teams
Install-WinGetPackageClean -Id Microsoft.VisualStudioCode -InstallType "SkipIfInstalled"
Install-WinGetPackageClean -Id Microsoft.WindowsTerminal
if (($Output = Install-WinGetPackageClean -Id FlorianHeidenreich.Mp3tag) -eq $INSTALLED_OR_UPGRADED) {
    regsvr32 /s "C:\Program Files\Mp3tag\Mp3tagShell.dll"
}
Write-Output $Output
Install-WinGetPackageClean -Id Insecure.Nmap
Install-WinGetPackageClean -Id Notepad++.Notepad++
Install-WinGetPackageClean -Id gsass1.NTop
Install-WinGetPackageClean -Id JanDeDobbeleer.OhMyPosh; oh-my-posh disable notice
Install-WinGetPackageClean -Id OPAutoClicker.OPAutoClicker
Install-WinGetPackageClean -Id dotPDN.PaintDotNet
Install-WinGetPackageClean -Id JohnMacFarlane.Pandoc
Install-WinGetPackageClean -Id PDFgear.PDFgear
Install-WinGetPackageClean -Id PDFLabs.PDFtk.Free
Install-WinGetPackageClean -Id BurntSushi.ripgrep.MSVC
Install-WinGetPackageClean -Id Scribus.Scribus
Install-WinGetPackageClean -Id RandyRants.SharpKeys
Install-WinGetPackageClean -Id SumatraPDF.SumatraPDF
if (($Output = Install-WinGetPackageClean -Id VideoLAN.VLC) -eq $INSTALLED_OR_UPGRADED) {
    & "C:\Program Files\VideoLAN\VLC\vlc-cache-gen.exe" "C:\Program Files\VideoLAN\VLC\plugins"
}
Write-Output $Output
Install-WinGetPackageClean -Id Microsoft.WindowsPCHealthCheck
Install-WinGetPackageClean -Id WinMerge.WinMerge
Install-WinGetPackageClean -Id WiresharkFoundation.Wireshark
Install-WinGetPackageClean -Id Zoom.Zoom
