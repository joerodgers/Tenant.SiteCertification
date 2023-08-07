function New-Configuration
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [DateTime]
        $ExecutionDate = [DateTime]::Today,

        [Parameter(Mandatory=$true)]
        [int]
        $VerificationIntervalDays,

        [Parameter(Mandatory=$true)]
        [int]
        $NotificationFrequencyDays,

        [Parameter(Mandatory=$true)]
        [int]
        $NotificationsBeforeNoAccessLock,

        [Parameter(Mandatory=$true)]
        [int]
        $LockedDaysBeforeDeletion
    )

    begin
    {
    }
    process
    {
        return New-Object Tenant.SiteCertification.Configuration -Property @{
            ExecutionDate                   = $ExecutionDate
            VerificationIntervalDays        = $VerificationIntervalDays
            NotificationFrequencyDays       = $NotificationFrequencyDays
            NotificationsBeforeNoAccessLock = $NotificationsBeforeNoAccessLock
            LockedDaysBeforeDeletion        = $LockedDaysBeforeDeletion
        }
    }
    end
    {
    }
}
