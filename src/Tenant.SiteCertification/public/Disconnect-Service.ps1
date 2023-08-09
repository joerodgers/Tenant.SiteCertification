function Disconnect-Service
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
        Clear-CachedObject -Name "DatabaseConnection" -ErrorAction Stop

        Clear-CachedObject -Name "TenantConnection" -ErrorAction Stop

        Write-PSFMessage -Message "Cached objects cleared successfully" -Level Verbose  
        
        try 
        {
            $null = Disconnect-PnPOnline -ErrorAction SilentlyContinue
        }
        catch
        {
        }
        
        Write-PSFMessage -Message "Disconnected from SharePoint Online" -Level Verbose  
    }
    end
    {
    }
}