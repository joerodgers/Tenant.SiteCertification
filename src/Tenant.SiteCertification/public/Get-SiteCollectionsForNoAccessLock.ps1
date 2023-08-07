function Get-SiteCollectionsForNoAccessLock
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

        Get-DataTable -StoredProcedure "sitecertification.proc_GetSiteCollectionsForNoAccessLock" -Parameters $parameters -As "PSObject"
    }
}