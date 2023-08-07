function Set-SiteCollectionUnlock
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
        Write-PSFMessage -Message "Setting site '$Uri' to 'Unlock'" -Level Verbose  

        Set-PnPTenantSite -Identity $Uri.ToString() -LockState Unlock -ErrorAction Stop

        Invoke-StoredProcedure -StoredProcedure "sitecertification.proc_RestartSiteCollectionCertification" -Parameters @{ siteUrl = $Uri.ToString() } -ErrorAction Stop

        try
        {
            Write-PSFMessage -Message "Removing site lock issue for '$Uri'" -Level Verbose  

            Set-Context -SiteUrl $Uri.ToString() -ErrorAction Stop
   
            # remove any lock issue values
            Remove-PnPPropertyBagValue -Key "vti_lockissue" -Force -ErrorAction Stop
        }
        finally
        {
            # revert back to admin site context
            $url = Get-SharePointTenantAdminUrl -ErrorAction Stop

            Set-Context -SiteUrl $url -ErrorAction Stop
        }
    }
}