function Get-SiteCollectionsForDeletion
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
    }
    process
    {
        $configuration = Get-DataTable -StoredProcedure "sitecertification.proc_GetSiteCertificationConfiguration" -As PSObject -ErrorAction Stop

        $parameters = @{ datetime = $configuration.ExecutionDate.AddDays( $configuration.LockedDaysBeforeDeletion * -1 ) }

        Get-DataTable -StoredProcedure "sitecertification.proc_GetSiteCollectionsForDeletion" -Parameters $parameters -As "PSObject" -ErrorAction Stop
    }
    end
    {
    }
}