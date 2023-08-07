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

        Clear-CachedObject -Name "Configuration" -ErrorAction Stop
    
        try 
        {
            $null = Disconnect-PnPOnline -ErrorAction SilentlyContinue
        }
        catch
        {
        }
    }
    end
    {
    }
}