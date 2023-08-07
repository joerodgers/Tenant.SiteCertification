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
        $configuration = Get-CachedObject -Name "Configuration" -ErrorAction Stop

        $parameters = @{
            notificationsBeforeNoAccessLock = $configuration.NotificationsBeforeNoAccessLock # just as a precaution
            datetime                        = $configuration.ExecutionDate.AddDays( $configuration.LockedDaysBeforeDeletion * -1 )
        }

        Get-DataTable -StoredProcedure "sitecertification.proc_GetSiteCollectionsForDeletion" -Parameters $parameters -As "PSObject" -ErrorAction Stop
    }
    end
    {
    }
}