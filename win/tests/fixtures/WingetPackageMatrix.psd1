@{
    Primary = @{
        FixedId = @{
            Name        = 'FixedId'
            Id          = 'Git.Git'
            InstallType = 'FixedId'
            Description = 'Known package ID with a normal install path.'
        }
        UnknownId = @{
            Name        = 'UnknownId'
            Id          = 'Python.Python.'
            InstallType = 'UnknownId'
            Description = 'Package ID still resolves through the unknown-id helper.'
        }
        UpgradeOnly = @{
            Name        = 'UpgradeOnly'
            Id          = 'Microsoft.PowerShell'
            InstallType = 'UpgradeOnly'
            Description = 'Upgrade path without a fresh install.'
        }
    }
    Secondary = @{
        SkipIfInstalled = @{
            Name        = 'SkipIfInstalled'
            Id          = 'Microsoft.VisualStudioCode'
            InstallType = 'SkipIfInstalled'
            Description = 'Should no-op when already present.'
        }
        DynamicId = @{
            Name        = 'DynamicId'
            Id          = 'EclipseAdoptium.Temurin'
            InstallType = 'DynamicId'
            Like        = '*JDK*'
            Description = 'Uses the dynamic ID resolver.'
        }
    }
}
