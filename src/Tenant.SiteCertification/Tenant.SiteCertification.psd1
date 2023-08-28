@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'Tenant.SiteCertification.psm1'

    # Version number of this module.
    ModuleVersion = '1.2.3'

    # ID used to uniquely identify this module
    GUID = '80c500e9-ce8f-4a13-8941-8a7247f61fbb'

    # Description of the functionality provided by this module
    Description = 'Module to download tenant site collection data to a SQL Server database'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '7.2'

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @{ModuleName="PSFramework";    ModuleVersion="1.8.291" },
                      @{ModuleName="PnP.PowerShell"; ModuleVersion="2.2.0"   }
    
    # Functions to export from this module
    FunctionsToExport = 'Connect-Service',
                        'Disconnect-Service',
                        'Get-SiteCollectionExclusion',
                        'Get-SiteCollectionsForDeletion',
                        'Get-SiteCollectionsForNoAccessLock',
                        'Get-SiteCollectionsForNotification',
                        'Invoke-SiteCollectionImport',
                        'New-DatabaseConnection',
                        'New-TenantConnection',
                        'New-Configuration',
                        'Set-SiteCollectionExclusion',
                        'Set-SiteCollectionLockState',
                        'Set-SiteCollectionNotificationCount',
                        'Start-LogFileLogger',
                        'Stop-LogFileLogger',
                        'Update-DatabaseSchema',
                        'Get-CachedObject',
                        'Set-SiteCollectionNoAccess',
                        'Set-SiteCollectionUnlock',
                        'Get-Configuration',
                        'Set-Configuration',
                        'Remove-SiteCollection'

    DefaultCommandPrefix = "SiteCertification" 
}
