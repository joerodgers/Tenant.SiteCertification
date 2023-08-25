function Remove-SiteCollection
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Uri]
        $Uri
    )

    $existingSite = Get-PnPTenantSite -Identity $Uri -ErrorAction Stop
    
    try
    {
        if( $existingSite.LockState -ne "UnLock" )
        {
            Write-PSFMessage -Message "Unlocking site collection: $Uri" -Level Verbose
            
            Set-PnPTenantSite -Url $Uri -LockState "Unlock" -ErrorAction Stop # unlock site to allow delete

            Start-Sleep -Seconds 5
        }

        Write-PSFMessage -Message "Deleting site collection: $Uri" -Level Verbose

        Remove-PnPTenantSite -Url $Uri -Force -ErrorAction Stop
    }
    catch
    {
        # revert any LockState change if any failures happened

        Set-PnPTenantSite -Url $Uri -LockState $existingSite.LockState -ErrorAction Stop

        Write-PSFMessage -Message "Failed to delete site: $Uri" -ErrorRecord $_ -EnableException $true -Level Critical
    }

    $json = [PSCustomObject] @{ SiteUrl = $Uri.ToString()} | ConvertTo-Json -Compress -AsArray

    Invoke-StoredProcedure -StoredProcedure "sitecertification.proc_DeleteSiteCollection" -Parameters @{ json = $json }
}