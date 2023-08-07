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
        $configuration = Get-CachedObject -Name "Configuration"

        try
        {
            Write-PSFMessage -Message "Updating site lock issue value on $($Uri). to 'NoAccess'" -Level Verbose  

            Set-Context -SiteUrl $Uri.ToString() -ErrorAction Stop
    
            # set the lock issue
            Add-PnPPropertyBagValue -Key "vti_lockissue" -Value "Locked 'No Access' on $([DateTime]::Today.ToString('MM/dd/yyyy')) due to expired certification."
        }
        finally
        {
            # revert back to admin site context
            $url = Get-SharePointTenantAdminUrl

            Set-Context -SiteUrl $url -ErrorAction Stop
        }

        Write-PSFMessage -Message "Setting site '$Uri' to 'NoAccess'" -Level Verbose  

        Set-PnPTenantSite -Identity $Uri.ToString() -LockState NoAccess -ErrorAction Stop

        Invoke-StoredProcedure -StoredProcedure "sitecertification.proc_SetSiteCollectionNoAccess" -Parameters @{ siteUrl = $Uri.ToString(); date = $configuration.ExecutionDate } -ErrorAction Stop
    }
}