function New-ConfidentialClientApplication
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Guid]
        $ClientId,

        [Parameter(Mandatory=$true)]
        [System.Security.Cryptography.X509Certificates.X509Certificate2]
        $Certificate,

        [Parameter(Mandatory=$true)]
        [Guid]
        $TenantId
    )

    $confidentialClientApplication = Get-CachedObject -Name "ConfidentialClientApplication"

    if( $null -eq $confidentialClientApplication )
    {
        $confidentialClientApplication = [Microsoft.Identity.Client.ConfidentialClientApplicationBuilder]::Create($ClientId). `
                                                                                WithCertificate($Certificate). `
                                                                                WithLegacyCacheCompatibility($false). `
                                                                                WithTenantId($TenantId). `
                                                                                Build()
        
        Set-CachedObject -Name "ConfidentialClientApplication" -Object $confidentialClientApplication
    }
   
    return $confidentialClientApplication
}