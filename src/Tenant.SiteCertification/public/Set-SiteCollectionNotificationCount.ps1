function Set-SiteCollectionNotificationCount
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
        $json = $Uri | Select-Object @{ Name="SiteUrl"; Expression={ $_.ToString() } } | ConvertTo-Json -Compress -AsArray
    
        Invoke-StoredProcedure -StoredProcedure "sitecertification.proc_IncrementSiteCollectionNotificationCount" -Parameters @{ json =  $json }
    }
}