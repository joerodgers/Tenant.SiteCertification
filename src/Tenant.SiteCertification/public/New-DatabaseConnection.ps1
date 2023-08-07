function New-DatabaseConnection
{
    [cmdletbinding(DefaultParameterSetName="TrustedConnection")]
    param
    (
        # Name of the SQL database
        [Parameter(Mandatory=$true,ParameterSetName="TrustedConnection")]
        [Parameter(Mandatory=$true,ParameterSetName="ServicePrincipalCertificate")]
        [string]
        $DatabaseName,

        # Name of the SQL server or SQL and instance name
        [Parameter(Mandatory=$true,ParameterSetName="TrustedConnection")]
        [Parameter(Mandatory=$true,ParameterSetName="ServicePrincipalCertificate")]
        [string]
        $DatabaseServer,

        # Connection timeout, default is 15
        [Parameter(Mandatory=$false)]
        [int]
        $ConnectTimeout = 15,

        [Parameter(Mandatory=$false)]
        [switch]
        $Encrypt,

        [Parameter(Mandatory=$true,ParameterSetName="ServicePrincipalCertificate")]
        [string]
        $ClientId,

        [Parameter(Mandatory=$true,ParameterSetName="ServicePrincipalCertificate")]
        [string]
        $CertificateThumbprint,

        [Parameter(Mandatory=$true,ParameterSetName="ServicePrincipalCertificate")]
        [string]
        $TenantId
    )

    begin
    {
    }
    process
    {
        if( $PSCmdlet.ParameterSetName -eq "TrustedConnection" )
        {
            return New-Object Tenant.SiteCertification.TrustedConnectionDatabaseConnection -Property @{ 
                DatabaseName   = $DatabaseName
                DatabaseServer = $DatabaseServer
                ConnectTimeout = $ConnectTimeout
                Encrypt        = $Encrypt.IsPresent
            }
        }
        
        if( $PSCmdlet.ParameterSetName -eq "ServicePrincipalCertificate" )
        {
            return New-Object Tenant.SiteCertification.ServicePrincipalDatabaseConnection -Property @{
                DatabaseName          = $DatabaseName
                DatabaseServer        = $DatabaseServer
                ConnectTimeout        = $ConnectTimeout
                Encrypt               = $true
                ClientId              = $ClientId
                CertificateThumbprint = $CertificateThumbprint
                TenantId              = $TenantId
            }
        }

        return $null
    }
    end
    {
    }
}

