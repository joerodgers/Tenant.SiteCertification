function Get-SharePointTenantAdminUrl
{
    [CmdletBinding()]
    param
    (
    )

    $tenantConnection = Get-CachedObject -Name "TenantConnection"
    
    $tenant = $tenantConnection.TenantName -Replace ".onmicrosoft.com", ""

    return "https://$($tenant)-admin.sharepoint.com"
}