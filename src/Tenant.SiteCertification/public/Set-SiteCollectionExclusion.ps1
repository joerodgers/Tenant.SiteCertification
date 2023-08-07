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

    Write-PSFMessage -Message "Setting site exclusion list to: $($Uri -join ", ")" -Level Verbose  

    Invoke-StoredProcedure -StoredProcedure "sitecertification.proc_MergeSiteCollectionExclusion" -Parameters @{ json =  $json }
}