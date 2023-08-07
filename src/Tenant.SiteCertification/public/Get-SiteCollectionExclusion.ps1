function Get-SiteCollectionExclusion
{
    [CmdletBinding()]
    param
    (
    )

    Get-DataTable -StoredProcedure "sitecertification.proc_GetSiteCollectionExclusion" -As "PSObject" -ErrorAction Stop
}