function Set-Context
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string]
        $SiteUrl
    )

    begin
    {
        $connection = Get-PnPConnection
        $context    = Get-PnPContext
    }
    process
    {
        $targetContext = [Microsoft.SharePoint.Client.ClientContextExtensions]::Clone($context, $SiteUrl)

        # hack for bug in PnP - https://github.com/pnp/PnP-PowerShell/issues/849
        $connection.GetType().GetProperty("Url").SetValue($connection, $SiteUrl)
        
        # set context to target site
        Set-PnPContext -Context $targetContext
      
        if( $SiteUrl -ne (Get-PnPConnection).Url )
        {
            throw "Failed to switch context to $SiteUrl"
        }
    }
    end
    {
    }
}