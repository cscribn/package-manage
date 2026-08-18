# delete pesky desktop shortcuts
function Remove-UnwantedShortcuts {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string[]]$Paths = @(),
        [Parameter(Mandatory=$false)]
        [string[]]$Patterns = @(
            'Blender *.lnk',
            'BlueStacks *.lnk',
            'Canon IJ Network Tool.lnk',
            'Chrome Remote Desktop.lnk',
            'DB Browser*.lnk',
            'DiskGenius.lnk',
            'DiskInternals*.lnk',
            'Docker Desktop.lnk',
            'DVD Decrypter.lnk',
            'DVD Flick.lnk',
            'EA.lnk',
            'Epic Games Launcher.lnk',
            'Firefox.lnk',
            'FlashPrint-MP.lnk',
            'FreeFileSync.lnk',
            'GIMP*.lnk',
            'Git SDK 64-bit.lnk',
            'GitHub Desktop.lnk',
            'Google Chrome.lnk',
            'Google Play*.lnk',
            'gVim*.lnk',
            'ImageMagick Display.lnk',
            'ImgBurn.lnk',
            'Inkscape.lnk',
            'Instant Eyedropper.lnk',
            'IrfanView*.lnk',
            'Krita.lnk',
            'LibreOffice *.lnk',
            'MakeMKV.lnk',
            'Microsoft Edge.lnk',
            'Mp3tag.lnk',
            'Nmap*.lnk',
            'Oracle VirtualBox.lnk',
            'paint.net.lnk',
            'Paragon Partition Manager*.lnk',
            'PDFgear.lnk',
            'Plantronics Hub.lnk',
            'Postman.lnk',
            'RealTimeSync.lnk',
            'Redragon * Keyboard.lnk',
            'Roblox Player.lnk',
            'Roblox Studio.lnk',
            'ScanSnap Home.lnk',
            'Scribus *.lnk',
            'SD Card Formatter.lnk',
            'SharpKeys.lnk',
            'SumatraPDF.lnk',
            'Twitch Studio.lnk',
            'Unity*.lnk',
            'VLC media player.lnk',
            'Zoom*.lnk'
        )
    )

    if (-not $Paths -or $Paths.Count -eq 0) {
        $Paths = @(
            (Join-Path -Path $env:PUBLIC -ChildPath 'Desktop'),
            (Join-Path -Path $env:USERPROFILE -ChildPath 'Desktop')
        )
    }

    foreach ($pattern in $Patterns) {
        Get-ChildItem -Path $Paths -Filter $pattern -ErrorAction SilentlyContinue |
            Remove-Item -Force -ErrorAction SilentlyContinue
    }
}

Remove-UnwantedShortcuts
