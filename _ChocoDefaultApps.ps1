# install apps
winget install 9NP83LWLPZ9K --silent --accept-package-agreements --accept-source-agreements # apple devices
winget install 9PKTQ5699M62 --silent --accept-package-agreements --accept-source-agreements # icloud
Get-AppxPackage Microsoft.MicrosoftSolitaireCollection -AllUsers | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register “$($_.InstallLocation)\AppXManifest.xml”} # microsoft solitaire

# remove apps all at once, due to https://github.com/PowerShell/PowerShell/issues/16652
$Session = New-PSSession -UseWindowsPowerShell; Invoke-Command -Session $Session { `
    Get-AppxPackage *ACGMediaPlayer* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *ActiproSoftwareLLC* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *AdobeSystemsIncorporated.AdobePhotoshopExpress* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Amazon.com.Amazon* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *AmazonVideo.PrimeVideo* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *AppUp.IntelConnectivityPerformanceSuite* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *AppUp.IntelGraphicsExperience* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *AppUp.IntelManagementandSecurityStatus* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Asphalt8Airborne* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *AutodeskSketchBook* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *CaesarsSlotsFreeCasino* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Clipchamp.Clipchamp* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *COOKINGFEVER* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *CyberLinkMediaSuiteEssentials* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Disney* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *DisneyMagicKingdoms* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Dolby* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *DrawboardPDF* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Duolingo-LearnLanguagesforFree* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *EclipseManager* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *E046963F.cameraSettings* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Facebook* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *FarmVille2CountryEscape* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *fitbit* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Flipboard* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *HiddenCity* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *HULULLC.HULUPLUS* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *iHeartRadio* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Instagram* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *king.com.BubbleWitch3Saga* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *LinkedInforWindows* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *MarchofEmpires* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.3DBuilder* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.549981C3F5F10* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.BingFinance* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.BingFoodAndDrink* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.BingHealthAndFitness* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.BingNews* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.BingSearch* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.BingSports* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.BingTranslator* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.BingTravel* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.BingWeather* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.Messaging* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.Microsoft3DViewer* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.MicrosoftJournal* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.MicrosoftOfficeHub* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.MicrosoftPowerBIForWindows* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.MicrosoftStickyNotes* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.MixedReality.Portal* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.NetworkSpeedTest* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.News* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.Office.OneNote* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.Office.Sway* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.OneConnect* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.Print3D* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.SkypeApp* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.Todos* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.WindowsAlarms* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.WindowsFeedbackHub* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.WindowsMaps* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.WindowsSoundRecorder* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.XboxApp* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Microsoft.ZuneVideo* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *MicrosoftCorporationII.MicrosoftFamily* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *MicrosoftTeams* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Netflix* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *NYTCrossword* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *OneCalendar* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *PandoraMediaInc* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *PhototasticCollage* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *PicsArt-PhotoStudio* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Plex* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *PolarrPhotoEditorAcademicEdition* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Royal Revolt* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Shazam* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Sidia.LiveWallpaper* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *SlingTV* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Speed Test* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Spotify* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *TikTok* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *TuneInRadio* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Twitter* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Viber* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *WinZipUniversal* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *Wunderlist* -AllUsers | Remove-AppxPackage -AllUsers; `
    Get-AppxPackage *XING* -AllUsers | Remove-AppxPackage -AllUsers; `
}; $Session | Remove-PSSession
