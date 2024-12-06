$typeDefinition = @'
namespace Tenant.SiteCertification
{
    public enum LockState
    {
        Unlock      = 0,
        ReadOnly    = 1,
        NoAccess    = 2,
        NoAdditions = 3 // added 12-06-2024 to prevent errors for write locked sites   
    }

    public class TenantSite
    {
        public System.DateTime? LastCertificationDate {get; set;} 

        public System.DateTime? LockDate {get; set;}

        public LockState LockState {get; set;}

        public int NoticeCount {get; set;}

        public string SiteUrl {get; set;}

        public string Template {get; set;}
    }
}
'@


if (-not ("Tenant.SiteCertification.TenantSite" -As [type] ))
{
    Add-Type -TypeDefinition $typeDefinition
}
