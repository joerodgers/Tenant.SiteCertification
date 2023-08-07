using namespace System.Collections.Generic
using namespace Microsoft.Identity.Web

function New-AzureSqlAccessToken
{
    [cmdletbinding()]
    param
    (
        # Azure AD App Principal Application/Client Id
        [Parameter(Mandatory=$true)]
        [string]
        $ClientId,

        # Azure AD App Principal Application/Client Secret
        [Parameter(Mandatory=$true)]
        [string]
        $CertificateThumbprint,

        # Azure AD TenantId
        [Parameter(Mandatory=$true)]
        [string]
        $TenantId
    )

    begin
    {
        $scopes = New-Object System.Collections.Generic.List[string]
        $scopes.Add("https://database.windows.net/.default")
    }
    process
    {
        $certificate = Get-ChildItem -Path Cert:\LocalMachine\My\$CertificateThumbprint -ErrorAction Stop

        if( $false )
        {
            $authenticationManager = [PnP.Framework.AuthenticationManager]::CreateWithCertificate( $ClientId, $certificate, $TenantId )
            
            $authenticationManager.GetAccessTokenAsync( @(,"https://database.windows.net/") ).GetAwaiter().GetResult()
        }
        else 
        {
            $confidentialClientApplication = New-ConfidentialClientApplication -ClientId $ClientId -Certificate $certificate -TenantId $TenantId

            $authenticationResult = $confidentialClientApplication. `
                                                AcquireTokenForClient( $scopes ). `
                                                ExecuteAsync(). `
                                                GetAwaiter(). `
                                                GetResult()

            $authenticationResult.AccessToken
        }
    }
}

