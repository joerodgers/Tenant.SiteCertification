function Set-Configuration
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $ConfigurationName,

        [Parameter(Mandatory=$true)]
        [string]
        $ConfigurationValue
    )
    
    Invoke-StoredProcedure -StoredProcedure "sitecertification.proc_SetSiteCertificationConfiguration" -Parameters @{ configurationName = $ConfigurationName; configurationValue = $ConfigurationValue }
}