function Get-ConfigurationValue
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $ConfigurationName
    )

    $configuration = Get-DataTable -StoredProcedure "sitecertification.proc_GetSiteCertificationConfiguration" -As PSObject -ErrorAction Stop

    return $configuration | Where-Object -Property ConfigurationName -eq $ConfigurationName | Select-Object -ExpandProperty ConfigurationValue
}