function Get-CachedObject
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string]
        $Name
    )

    if( $variable = Get-Variable -Name "Tenant.SiteCertification.$Name" -Scope "Script" -ErrorAction Ignore  )
    {
        return $variable.Value
    }
}