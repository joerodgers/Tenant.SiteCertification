function Get-SiteCollectionsForNoAccessLock
{   
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [DateTime]
        $DateTime = [DateTime]::Today
    )

    process
    {
        Get-DataTable -StoredProcedure "sitecertification.proc_GetSiteCollectionsForNoAccessLock" -Parameters @{ datetime = $DateTime } -As "PSObject"
    }
}