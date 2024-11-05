# Data Collection - disable telemetry
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection", "AllowTelemetry", 0)

# Explorer - launch to This PC
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "LaunchTo", 1)

# Explorer - show file extensions
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "HideFileExt", 0)

# Explorer - show hidden files
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden", 1)

# Feedback - never
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Siuf\Rules", "NumberOfSIUFInPeriod", 0); `
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" –Name "PeriodInNanoSeconds" -ErrorAction SilentlyContinue

# File Associations - prevent photos reset
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppXk0g4vb8gvt7b93tg50ybcy892pge6jmt" –Name "NoOpenWith" -ErrorAction SilentlyContinue; `
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" –Name "NoOpenWith" -ErrorAction SilentlyContinue; `
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppX9rkaq77s0jzh1tyccadx9ghba15r6t3h" –Name "NoOpenWith" -ErrorAction SilentlyContinue

# File Associations - prevent music reset
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" –Name "NoOpenWith" -ErrorAction SilentlyContinue

# File Associations - prevent video reset
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" –Name "NoOpenWith" -ErrorAction SilentlyContinue

# Finish Setting Up - disable suggestions
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement", "ScoobeSystemSettingEnabled", 0)

# Google Chrome - remote access Curtain Mode
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome", "RemoteAccessHostRequireCurtain", 1); `
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server", "fDenyTSConnections", 0); `
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp", "UserAuthentication", 0); `
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp", "SecurityLayer", 1)

# Inking & Typing - disable personalization
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\InputPersonalization", "RestrictImplicitInkCollection", 1); `
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\InputPersonalization", "RestrictImplicitTextCollection", 1); `
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\InputPersonalization\TrainedDataStore", "HarvestContacts", 0); `
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Personalization\Settings", "AcceptedPrivacyPolicy", 0)

# Inking & Typing - disable recognition
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Input\TIPC", "Enabled", 0)

# Lock Screen - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization", "NoLockScreen", 1)

# Login Screen - wallpaper
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization", "LockScreenImage", 1); `
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP", "LockScreenImageStatus", "C:\Windows\Web\Wallpaper\Windows\img19.jpg"); `
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP", "LockScreenImagePath", "C:\Windows\Web\Wallpaper\Windows\img19.jpg"); `
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP", "LockScreenImageUrl", "C:\Windows\Web\Wallpaper\Windows\img19.jpg"); `
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PersonalizationP", "NoChangingLockScreen", 1)

# Modern Standby - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power", "PlatformAoAcOverride", 0)

# Phone Link - disable suggestions
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Mobility", "OptedIn", 0)

# Right-Click - use old
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32", "", "")

# Scrollbars - always show
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Control Panel\Accessibility", "DynamicScrollbars", 0)

# Settings - disable suggested
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SubscribedContent-338393Enabled", 0); `
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SubscribedContent-353694Enabled", 0); `
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SubscribedContent-353696Enabled", 0); `
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SubscribedContent-353698Enabled", 0)

# Speech Recognition - disable online
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy", "HasAccepted", 0)

# Start Menu - disable Internet search
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer", "DisableSearchBoxSuggestions", 1)

# Start Menu - disable recommendations
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Start_IrisRecommendations", 0)

# Start Menu - disable suggestions
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SubscribedContent-338388Enabled", 0); `
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SystemPaneSuggestionsEnabled", 0)

# Suggested Apps - disable install
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SilentInstalledAppsEnabled", 0)

# Suggested Apps - disable notifications
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.Suggested", "Enabled", 0)

# Suggestions - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SubscribedContent-338389Enabled", 0); `
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SoftLandingEnabled", 0)

# Tailored Experiences - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Privacy", "TailoredExperiencesWithDiagnosticDataEnabled", 0)

# Taskbar - align left
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "TaskbarAl", 0)

# Taskbar - disable chat
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "TaskbarMn", 0)

# Taskbar - disable copilot
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "ShowCopilotButton", 0)

# Taskbar - disable search
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search", "SearchboxTaskbarMode", 0)

# Taskbar - disable task view
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "ShowTaskViewButton", 0)

# Taskbar - disable widgets
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Dsh", "AllowNewsAndInterests", 0)

# Task Manager - enable
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\4\1887869580", "EnabledState", 2)

# Welcome Experience - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SubscribedContent-310093Enabled", 0)
