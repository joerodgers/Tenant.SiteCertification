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
        $TenantConnection
    )
   
    Set-CachedObject -Name "DatabaseConnection" -Object $DatabaseConnection -ErrorAction Stop

    Set-CachedObject -Name "TenantConnection" -Object $TenantConnection -ErrorAction Stop

    Connect-SharePointTenant -ErrorAction Stop

    Write-PSFMessage -Message "Connected to SiteCertification Service" -Level Verbose  
}