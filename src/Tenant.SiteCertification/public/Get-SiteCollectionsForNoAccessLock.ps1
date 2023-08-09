function Get-SiteCollectionsForNoAccessLock
{   
    [CmdletBinding()]
    param
    (
    )

    process
    {
        $configuration = Get-DataTable -StoredProcedure "sitecertification.proc_GetSiteCertificationConfiguration" -As PSObject -ErrorAction Stop

        $parameters = @{
            datetime                        = $configuration.ExecutionDate
            notificationsBeforeNoAccessLock = $configuration.NotificationsBeforeNoAccessLock
            verificationIntervalDays        = $configuration.VerificationIntervalDays
            notificationFrequencyDays       = $configuration.NotificationFrequencyDays
        }

        Get-DataTable -StoredProcedure "sitecertification.proc_GetSiteCollectionsForNoAccessLock" -Parameters $parameters -As "PSObject"
    }
}