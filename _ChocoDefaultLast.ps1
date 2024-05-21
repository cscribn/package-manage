. $PSScriptRoot\_ChocoDefaultConfig.ps1

# upgrade all choco
choco feature enable -n useRememberedArgumentsForUpgrades
choco upgrade all -y

# delete pesky desktop shortcuts
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "BlueStacks *.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Canon IJ Network Tool.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Chrome Remote Desktop.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "DiskInternals Research.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "DVD Decrypter.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "DVD Flick.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "EA.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Epic Games Launcher.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "FlashPrint-MP.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Firefox.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "FreeFileSync.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "GitHub Desktop.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Google Chrome.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Google Play*.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "ImageMagick Display.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "ImgBurn.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Inkscape.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Instant Eyedropper.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "LibreOffice *.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "MakeMKV.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Microsoft Edge.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Mp3tag.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "paint.net.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Paragon Partition Manager*.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Plantronics Hub.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "RealTimeSync.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Redragon * Keyboard.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Roblox Player.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Roblox Studio.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "ScanSnap Home.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Scribus *.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "SD Card Formatter.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "SharpKeys.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "SumatraPDF.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Unity*.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "VLC media player.lnk" | Remove-Item
Get-ChildItem -Path $env:PUBLIC\Desktop,$env:USERPROFILE\Desktop -Filter "Zoom*.lnk" | Remove-Item
