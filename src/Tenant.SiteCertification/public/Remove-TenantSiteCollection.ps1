function Remove-TenantSiteCollection
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Uri]
        $Uri,

        [Parameter(Mandatory=$false)]
        [switch]
        $DatabaseOnly,

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf

    )

    if( $WhatIf.IsPresent )
    {
        Write-PSFMessage -Message "Would have deleted $Uri"
    }
    else
    {
        if( -not $DatabaseOnly.IsPresent )
        {
            Write-PSFMessage -Message "Deleting site collection: $Uri" -Level Verbose

            Remove-PnPTenantSite -Url $Uri -Force -ErrorAction Stop
        }
    }

    $json = [PSCustomObject] @{ SiteUrl = $Uri.ToString()} | ConvertTo-Json -Compress -AsArray

    Invoke-StoredProcedure -StoredProcedure "sitecertification.proc_DeleteSiteCollection" -Parameters @{ json = $json }
}