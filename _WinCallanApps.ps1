$version = (Get-CimInstance Win32_OperatingSystem).Version

# install apps
winget install 9NP83LWLPZ9K --silent --accept-package-agreements --accept-source-agreements # apple devices
winget install 9PKTQ5699M62 --silent --accept-package-agreements --accept-source-agreements # icloud

if ($version -notlike '10.*') {
    Get-AppxPackage Microsoft.MicrosoftSolitaireCollection | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register “$($_.InstallLocation)\AppXManifest.xml”} # microsoft solitaire
}

# remove apps all at once, due to https://github.com/PowerShell/PowerShell/issues/16652
$Session = New-PSSession -UseWindowsPowerShell; Invoke-Command -Session $Session { `
    Get-AppxPackage *ACGMediaPlayer* | Remove-AppxPackage; `
    Get-AppxPackage *ActiproSoftwareLLC* | Remove-AppxPackage; `
    Get-AppxPackage *AdobeSystemsIncorporated.AdobePhotoshopExpress* | Remove-AppxPackage; `
    Get-AppxPackage *Amazon.com.Amazon* | Remove-AppxPackage; `
    Get-AppxPackage *AmazonVideo.PrimeVideo* | Remove-AppxPackage; `
    Get-AppxPackage *AppUp.IntelConnectivityPerformanceSuite* | Remove-AppxPackage; `
    Get-AppxPackage *AppUp.IntelGraphicsExperience* | Remove-AppxPackage; `
    Get-AppxPackage *AppUp.IntelManagementandSecurityStatus* | Remove-AppxPackage; `
    Get-AppxPackage *Asphalt8Airborne* | Remove-AppxPackage; `
    Get-AppxPackage *AutodeskSketchBook* | Remove-AppxPackage; `
    Get-AppxPackage *CaesarsSlotsFreeCasino* | Remove-AppxPackage; `
    Get-AppxPackage *Clipchamp.Clipchamp* | Remove-AppxPackage; `
    Get-AppxPackage *COOKINGFEVER* | Remove-AppxPackage; `
    Get-AppxPackage *CyberLinkMediaSuiteEssentials* | Remove-AppxPackage; `
    Get-AppxPackage *Disney* | Remove-AppxPackage; `
    Get-AppxPackage *DisneyMagicKingdoms* | Remove-AppxPackage; `
    Get-AppxPackage *Dolby* | Remove-AppxPackage; `
    Get-AppxPackage *DrawboardPDF* | Remove-AppxPackage; `
    Get-AppxPackage *Duolingo-LearnLanguagesforFree* | Remove-AppxPackage; `
    Get-AppxPackage *EclipseManager* | Remove-AppxPackage; `
    Get-AppxPackage *E046963F.cameraSettings* | Remove-AppxPackage; `
    Get-AppxPackage *Facebook* | Remove-AppxPackage; `
    Get-AppxPackage *FarmVille2CountryEscape* | Remove-AppxPackage; `
    Get-AppxPackage *fitbit* | Remove-AppxPackage; `
    Get-AppxPackage *Flipboard* | Remove-AppxPackage; `
    Get-AppxPackage *HiddenCity* | Remove-AppxPackage; `
    Get-AppxPackage *HULULLC.HULUPLUS* | Remove-AppxPackage; `
    Get-AppxPackage *iHeartRadio* | Remove-AppxPackage; `
    Get-AppxPackage *Instagram* | Remove-AppxPackage; `
    Get-AppxPackage *king.com.BubbleWitch3Saga* | Remove-AppxPackage; `
    Get-AppxPackage *LinkedInforWindows* | Remove-AppxPackage; `
    Get-AppxPackage *MarchofEmpires* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.3DBuilder* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.549981C3F5F10* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.BingFinance* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.BingFoodAndDrink* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.BingHealthAndFitness* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.BingSearch* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.BingSports* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.BingTranslator* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.BingTravel* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.BingWeather* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.Messaging* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.Microsoft3DViewer* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.MicrosoftJournal* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.MicrosoftOfficeHub* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.MicrosoftPowerBIForWindows* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.MicrosoftStickyNotes* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.MixedReality.Portal* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.NetworkSpeedTest* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.News* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.Office.OneNote* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.Office.Sway* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.OneConnect* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.Print3D* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.SkypeApp* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.StartExperiencesApp* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.Todos* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.WindowsAlarms* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.WindowsMaps* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.WindowsSoundRecorder* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.XboxApp* | Remove-AppxPackage; `
    Get-AppxPackage *Microsoft.ZuneVideo* | Remove-AppxPackage; `
    Get-AppxPackage *MicrosoftCorporationII.MicrosoftFamily* | Remove-AppxPackage; `
    Get-AppxPackage *MicrosoftTeams* | Remove-AppxPackage; `
    Get-AppxPackage *MirametrixInc.GlancebyMirametrix* | Remove-AppxPackage; `
    Get-AppxPackage *Netflix* | Remove-AppxPackage; `
    Get-AppxPackage *NYTCrossword* | Remove-AppxPackage; `
    Get-AppxPackage *OneCalendar* | Remove-AppxPackage; `
    Get-AppxPackage *PandoraMediaInc* | Remove-AppxPackage; `
    Get-AppxPackage *PhototasticCollage* | Remove-AppxPackage; `
    Get-AppxPackage *PicsArt-PhotoStudio* | Remove-AppxPackage; `
    Get-AppxPackage *Plex* | Remove-AppxPackage; `
    Get-AppxPackage *PolarrPhotoEditorAcademicEdition* | Remove-AppxPackage; `
    Get-AppxPackage *Royal Revolt* | Remove-AppxPackage; `
    Get-AppxPackage *Shazam* | Remove-AppxPackage; `
    Get-AppxPackage *Sidia.LiveWallpaper* | Remove-AppxPackage; `
    Get-AppxPackage *SlingTV* | Remove-AppxPackage; `
    Get-AppxPackage *Speed Test* | Remove-AppxPackage; `
    Get-AppxPackage *Spotify* | Remove-AppxPackage; `
    Get-AppxPackage *TikTok* | Remove-AppxPackage; `
    Get-AppxPackage *TuneInRadio* | Remove-AppxPackage; `
    Get-AppxPackage *Twitter* | Remove-AppxPackage; `
    Get-AppxPackage *Viber* | Remove-AppxPackage; `
    Get-AppxPackage *WinZipUniversal* | Remove-AppxPackage; `
    Get-AppxPackage *Wunderlist* | Remove-AppxPackage; `
    Get-AppxPackage *XING* | Remove-AppxPackage; `
}; $Session | Remove-PSSession
