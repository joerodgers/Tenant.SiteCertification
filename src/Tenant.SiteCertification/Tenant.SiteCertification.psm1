# auto generated by src\build\Compile-ModuleManefest.ps1 on 12/06/2024 16:48:22

# class file - src\Tenant.SiteCertification\private\classes\DatabaseConnection.ps1
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



# class file - src\Tenant.SiteCertification\private\classes\Notification.ps1
class Notification
{
    [Guid]
    $SiteId

    [DateTime]
    $NoticeDate

    [string]
    $NoticeRecipients
}

# class file - src\Tenant.SiteCertification\private\classes\TenantConnection.ps1
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


# class file - src\Tenant.SiteCertification\private\classes\TenantSite.ps1
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



# private function import
foreach ($function in (Get-ChildItem "$PSScriptRoot\private" -Filter "*.ps1" -Recurse -ErrorAction Ignore | Sort-Object -Property FullName ))
{
    Write-Verbose "Importing private file: '$($function.FullName)'"

    . $function.FullName
}


# public function import
foreach ($function in (Get-ChildItem "$PSScriptRoot\public" -Filter "*.ps1" -Recurse -ErrorAction Ignore | Sort-Object -Property FullName ))
{
    Write-Verbose "Importing public file: '$($function.FullName)'"

    . $function.FullName
}


