function Connect-SharePointTenant
{
    [CmdletBinding()]
    param 
    (
    )
    
    begin
    {
    }
    process
    {
        Assert-ServiceConnection -Cmdlet $PSCmdlet

        $tenantConnection = Get-CachedObject -Name "TenantConnection" -ErrorAction Stop

        if( [PnP.PowerShell.Commands.Base.PnPConnection]::Current -and 
           ([PnP.PowerShell.Commands.Base.PnPConnection]::Current.ClientId -ne $tenantConnection.ClientId.ToString() -or 
            [PnP.PowerShell.Commands.Base.pnpconnection]::Current.ConnectionType -ne [PnP.PowerShell.Commands.Enums.ConnectionType]::TenantAdmin))
        {
            Disconnect-PnPOnline -ErrorAction SilentlyContinue
        }

        try 
        {
            $tenantAdminUrl = Get-SharePointTenantAdminUrl -ErrorAction Stop
    
            Connect-PnPOnline `
                        -Url        $tenantAdminUrl `
                        -ClientId   $tenantConnection.ClientId.ToString() `
                        -Thumbprint $tenantConnection.CertificateThumbprint `
                        -Tenant     $tenantConnection.TenantId.ToString() `
                        -ErrorAction Stop
        }
        catch
        {
            Write-PSFMessage -Message "Failed to connect to SharePoint tenant admin at $tenantAdminUrl" -EnableException $true -ErrorRecord $_ -Level Critical
        }
    }
    end
    {
    }
}