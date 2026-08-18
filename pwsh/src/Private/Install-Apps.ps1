[CmdletBinding()]
$Global:InformationPreference = 'Continue'

Import-Module "$PSScriptRoot\WingetUtils.psm1" -Force

# appx
Get-AppxPackage Microsoft.MicrosoftSolitaireCollection | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register “$($_.InstallLocation)\AppXManifest.xml”} # microsoft solitaire

# winget
Install-WinGetPackageClean -Id 9NP83LWLPZ9K # apple devices
Install-WinGetPackageClean -Id 9PKTQ5699M62 # icloud

function Remove-AppxPackagesFromSession {
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$PackagePatterns
    )

    $Session = New-PSSession -UseWindowsPowerShell
    try {
        Invoke-Command -Session $Session -ScriptBlock {
            param($Patterns)

            foreach ($pattern in $Patterns) {
                Get-AppxPackage $pattern | Remove-AppxPackage
            }
        } -ArgumentList ($PackagePatterns)
    } finally {
        if ($Session) {
            $Session | Remove-PSSession
        }
    }
}

# remove apps; do all at once, due to https://github.com/PowerShell/PowerShell/issues/16652
Remove-AppxPackagesFromSession -PackagePatterns @(
    '*ACGMediaPlayer*',
    '*ActiproSoftwareLLC*',
    '*AdobeSystemsIncorporated.AdobePhotoshopExpress*',
    '*Amazon.com.Amazon*',
    '*AmazonVideo.PrimeVideo*',
    '*AppUp.IntelConnectivityPerformanceSuite*',
    '*AppUp.IntelGraphicsExperience*',
    '*AppUp.IntelManagementandSecurityStatus*',
    '*Asphalt8Airborne*',
    '*AutodeskSketchBook*',
    '*CaesarsSlotsFreeCasino*',
    '*Clipchamp.Clipchamp*',
    '*COOKINGFEVER*',
    '*CyberLinkMediaSuiteEssentials*',
    '*Disney*',
    '*DisneyMagicKingdoms*',
    '*Dolby*',
    '*DrawboardPDF*',
    '*Duolingo-LearnLanguagesforFree*',
    '*EclipseManager*',
    '*E046963F.cameraSettings*',
    '*Facebook*',
    '*FarmVille2CountryEscape*',
    '*fitbit*',
    '*Flipboard*',
    '*HiddenCity*',
    '*HULULLC.HULUPLUS*',
    '*iHeartRadio*',
    '*Instagram*',
    '*king.com.BubbleWitch3Saga*',
    '*LinkedInforWindows*',
    '*MarchofEmpires*',
    '*Microsoft.3DBuilder*',
    '*Microsoft.549981C3F5F10*',
    '*Microsoft.BingFinance*',
    '*Microsoft.BingFoodAndDrink*',
    '*Microsoft.BingHealthAndFitness*',
    '*Microsoft.BingNews*',
    '*Microsoft.BingSearch*',
    '*Microsoft.BingSports*',
    '*Microsoft.BingTranslator*',
    '*Microsoft.BingTravel*',
    '*Microsoft.BingWeather*',
    '*Microsoft.Messaging*',
    '*Microsoft.Microsoft3DViewer*',
    '*Microsoft.MicrosoftJournal*',
    '*Microsoft.MicrosoftOfficeHub*',
    '*Microsoft.MicrosoftPowerBIForWindows*',
    '*Microsoft.MicrosoftStickyNotes*',
    '*Microsoft.MixedReality.Portal*',
    '*Microsoft.NetworkSpeedTest*',
    '*Microsoft.News*',
    '*Microsoft.Office.OneNote*',
    '*Microsoft.Office.Sway*',
    '*Microsoft.OneConnect*',
    '*Microsoft.Print3D*',
    '*Microsoft.SkypeApp*',
    '*Microsoft.StartExperiencesApp*',
    '*Microsoft.Todos*',
    '*Microsoft.WindowsAlarms*',
    '*Microsoft.WindowsFeedbackHub*',
    '*Microsoft.WindowsMaps*',
    '*Microsoft.WindowsSoundRecorder*',
    '*Microsoft.XboxApp*',
    '*Microsoft.ZuneVideo*',
    '*MicrosoftCorporationII.MicrosoftFamily*',
    '*MirametrixInc.GlancebyMirametrix*',
    '*Netflix*',
    '*NYTCrossword*',
    '*OneCalendar*',
    '*PandoraMediaInc*',
    '*PhototasticCollage*',
    '*PicsArt-PhotoStudio*',
    '*Plex*',
    '*PolarrPhotoEditorAcademicEdition*',
    '*Royal Revolt*',
    '*Shazam*',
    '*Sidia.LiveWallpaper*',
    '*SlingTV*',
    '*Speed Test*',
    '*Spotify*',
    '*TikTok*',
    '*TuneInRadio*',
    '*Twitter*',
    '*Viber*',
    '*WinZipUniversal*',
    '*Wunderlist*',
    '*XING*'
) ]
