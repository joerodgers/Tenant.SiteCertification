function New-TenantConnection
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Guid]
        $ClientId,

        [Parameter(Mandatory=$true)]
        [string]
        $CertificateThumbprint,

        [Parameter(Mandatory=$true)]
        [string]
        $TenantName,

        [Parameter(Mandatory=$true)]
        [Guid]
        $TenantId
    )

    begin
    {
        $TenantName = $TenantName -replace "\.onmicrosoft\.com", ""
    }
    process
    {
        return New-Object Tenant.SiteCertification.ServicePrincipalTenantConnection -Property @{
            TenantId              = $TenantId
            TenantName            = $TenantName
            ClientId              = $ClientId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
    end
    {
    }
}
