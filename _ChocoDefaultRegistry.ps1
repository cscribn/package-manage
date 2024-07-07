# Data Collection - remove telemetry
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection", "AllowTelemetry", 0)

# Feedback - never
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Siuf\Rules", "NumberOfSIUFInPeriod", 0)
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" –Name "PeriodInNanoSeconds" -ErrorAction SilentlyContinue

# Google Chrome - remote access Curtain Mode
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome", "RemoteAccessHostRequireCurtain", 1); `
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server", "fDenyTSConnections", 0); `
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp", "UserAuthentication", 0); `
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp", "SecurityLayer", 1)

# Inking & Typing Personalization - remove
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\InputPersonalization", "RestrictImplicitInkCollection", 1); `
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\InputPersonalization", "RestrictImplicitTextCollection", 1); `
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\InputPersonalization\TrainedDataStore", "HarvestContacts", 0); `
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Personalization\Settings", "AcceptedPrivacyPolicy", 0); `

# Inking & Typing Recognition - remove
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Input\TIPC", "Enabled", 0)

# Lock Screen - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization", "NoLockScreen", 1)

# Prevent file association reset - Photos
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppXk0g4vb8gvt7b93tg50ybcy892pge6jmt" –Name "NoOpenWith" -ErrorAction SilentlyContinue; `
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" –Name "NoOpenWith" -ErrorAction SilentlyContinue; `
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppX9rkaq77s0jzh1tyccadx9ghba15r6t3h" –Name "NoOpenWith" -ErrorAction SilentlyContinue

# Prevent file association reset - Music
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" –Name "NoOpenWith" -ErrorAction SilentlyContinue

# Prevent file association reset - Video
Remove-ItemProperty –Path "HKCU:\SOFTWARE\Classes\AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" –Name "NoOpenWith" -ErrorAction SilentlyContinue

# Modern Standby - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power", "PlatformAoAcOverride", 0)

# Right-Click - old
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32", "", "")

# Speech Recognition Online - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy", "HasAccepted", 0)

# Start Menu - disable Internet search
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer", "DisableSearchBoxSuggestions", 1)

# Tailored Experiences - remove
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Privacy", "TailoredExperiencesWithDiagnosticDataEnabled", 0)

# Taskbar align left
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "TaskbarAl", 0)

# Taskbar Chat - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "TaskbarMn", 0)

# Taskbar Copilot - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "ShowCopilotButton", 0)

# Taskbar Widgets - disable
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "TaskbarDa", 0)

# Task Manager - enable
[Microsoft.Win32.Registry]::SetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\4\1887869580", "EnabledState", 2)

# TODO - Left off at https://github.com/Raphire/Win11Debloat/blob/master/Regfiles/Disable_Windows_Suggestions.reg
