function Set-SiteCollectionNoAccess
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Uri]
        $Uri
    )

    process
    {
        $site = Get-PnPTenantSite -Identity $Uri.ToString() -ErrorAction Stop

        if( $site.LockState -ne "NoAcesss" )
        {
            Write-PSFMessage -Message "Setting site '$Uri' to 'NoAccess'" -Level Verbose  

            Set-PnPTenantSite -Identity $Uri.ToString() -LockState NoAccess -ErrorAction Stop
        }
        else
        {
            Write-PSFMessage -Message "Site '$Uri' is already set to '$($site.LockState)'" -Level Verbose  
        }

        Invoke-StoredProcedure -StoredProcedure "sitecertification.proc_SetSiteCollectionNoAccess" -Parameters @{ siteUrl = $Uri.ToString(); date = Get-Date } -ErrorAction Stop
    }
}