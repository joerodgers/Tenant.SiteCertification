$typeDefinition = @'
namespace Tenant.SiteCertification
{
    public abstract class DatabaseConnection
    {
        public string DatabaseName {get;set;} 

        public string DatabaseServer {get;set;}

        public int ConnectTimeout {get;set;} = 15;

        public bool Encrypt {get;set;} = true;
    }

    public class ServicePrincipalDatabaseConnection : DatabaseConnection
    {
        public System.Guid ClientId = System.Guid.Empty;

        public System.Guid TenantId = System.Guid.Empty;

        public string CertificateThumbprint = string.Empty;
    }

    public class TrustedConnectionDatabaseConnection : DatabaseConnection
    {
    }
}
'@

if (-not ("Tenant.SiteCertification.DatabaseConnection" -As [type] ))
{
    Add-Type -TypeDefinition $typeDefinition
}

