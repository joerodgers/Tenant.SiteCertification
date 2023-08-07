function Get-SiteCollectionsForNotification
{   
    [CmdletBinding()]
    param
    (
    )

    process
    {
        $configuration = Get-CachedObject -Name "Configuration" -ErrorAction Stop

        $parameters = @{
            datetime                        = $configuration.ExecutionDate
            notificationsBeforeNoAccessLock = $configuration.NotificationsBeforeNoAccessLock
            verificationIntervalDays        = $configuration.VerificationIntervalDays
            notificationFrequencyDays       = $configuration.NotificationFrequencyDays
        }

        Get-DataTable -StoredProcedure "sitecertification.proc_GetSiteCollectionsForNotification" -Parameters $parameters -As "PSObject" -ErrorAction Stop
    }
}