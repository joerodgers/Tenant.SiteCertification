$typeDefinition = @'
namespace Tenant.SiteCertification
{
    public abstract class TenantConnection
    {
        public System.Guid TenantId {get;set;} 

        public string TenantName {get;set;}
    }

    public class ServicePrincipalTenantConnection : TenantConnection
    {
        public System.Guid ClientId = System.Guid.Empty;

        public string CertificateThumbprint = string.Empty;
    }

    public class SystemAssignedManagedIdentityTenantConnection : TenantConnection
    {
    }
}
'@

if (-not ("Tenant.SiteCertification.TenantConnection" -As [type] ))
{
    Add-Type -TypeDefinition $typeDefinition
}
