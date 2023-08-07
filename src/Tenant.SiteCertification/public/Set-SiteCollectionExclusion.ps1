function Set-SiteCollectionExclusion
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string[]]
        $Uri
    )
    
    $json = $Uri | Select-Object @{ Name="SiteUrl"; Expression={ $_.ToString() } } | ConvertTo-Json -Compress -AsArray

    Invoke-StoredProcedure -StoredProcedure "sitecertification.proc_MergeSiteCollectionExclusion" -Parameters @{ json =  $json }
}