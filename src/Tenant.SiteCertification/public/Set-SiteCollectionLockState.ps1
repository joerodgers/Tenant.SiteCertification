function Set-SiteCollectionLockState
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Uri]
        $Uri,

        [Parameter(Mandatory=$true,ParameterSetName="NoAccess")]
        [switch]
        $NoAccess,

        [Parameter(Mandatory=$true,ParameterSetName="Unlock")]
        [switch]
        $UnLock,

        [Parameter(Mandatory=$true,ParameterSetName="Unlock")]
        [switch]
        $ResetCertification

    )

    process
    {
        if( $cmdlet.ParameterSetName -eq "NoAccess" )
        {
            try
            {
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

            Set-PnPTenantSite -Identity $Uri.ToString() -LockState NoAccess -ErrorAction Stop
        
            # update database
        }
        elseif( $cmdlet.ParameterSetName -eq "NoAccess" )
        {
            Set-PnPTenantSite -Identity $Uri.ToString() -LockState Unlock -ErrorAction Stop

            try
            {
                Set-Context -SiteUrl $Uri.ToString() -ErrorAction Stop
       
                # remove any lock issue values
                Remove-PnPPropertyBagValue -Key "vti_lockissue" -Force
            }
            finally
            {
                # revert back to admin site context
                $url = Get-SharePointTenantAdminUrl

                Set-Context -SiteUrl $url -ErrorAction Stop
            }

            # update database


        }
    }
}