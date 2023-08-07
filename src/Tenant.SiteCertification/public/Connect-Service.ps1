function Connect-Service
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Tenant.SiteCertification.DatabaseConnection]
        $DatabaseConnection,

        [Parameter(Mandatory=$true)]
        [Tenant.SiteCertification.TenantConnection]
        $TenantConnection,

        [Parameter(Mandatory=$true)]
        [Tenant.SiteCertification.Configuration]
        $Configuration
    )
   
    Set-CachedObject -Name "DatabaseConnection" -Object $DatabaseConnection -ErrorAction Stop

    Set-CachedObject -Name "TenantConnection" -Object $TenantConnection -ErrorAction Stop

    Set-CachedObject -Name "Configuration" -Object $Configuration -ErrorAction Stop

    Connect-SharePointTenant -ErrorAction Stop
}