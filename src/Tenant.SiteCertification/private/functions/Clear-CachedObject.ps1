function Clear-CachedObject
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $Name
    )

    Clear-Variable -Name "Tenant.SiteCertification.$Name" -Scope "Script" -Force
}