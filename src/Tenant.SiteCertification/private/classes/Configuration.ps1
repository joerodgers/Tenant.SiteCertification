$typeDefinition = @'
namespace Tenant.SiteCertification
{
    public class Configuration
    {
        public System.DateTime ExecutionDate { get; set; } = System.DateTime.Today;

        public int VerificationIntervalDays { get; set; } = 90;

        public int NotificationFrequencyDays { get; set; } = 7;

        public int NotificationsBeforeNoAccessLock { get; set; } = 6;

        public int LockedDaysBeforeDeletion { get; set; } = 45;
    }
}
'@

if (-not ("Tenant.SiteCertification.Configuration" -As [type] ))
{
    Add-Type -TypeDefinition $typeDefinition
}