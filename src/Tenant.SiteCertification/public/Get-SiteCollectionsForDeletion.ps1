function Get-SiteCollectionsForDeletion
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [DateTime]
        $DateTime = [datetime]::Today
    )

    begin
    {
    }
    process
    {
        [int] $lockedDaysBeforeDeletion = Get-ConfigurationValue -ConfigurationName "LockedDaysBeforeDeletion"

        $parameters = @{ datetime = $DateTime.AddDays( $lockedDaysBeforeDeletion * -1 ) }

        Get-DataTable -StoredProcedure "sitecertification.proc_GetSiteCollectionsForDeletion" -Parameters $parameters -As "PSObject" -ErrorAction Stop
    }
    end
    {
    }
}