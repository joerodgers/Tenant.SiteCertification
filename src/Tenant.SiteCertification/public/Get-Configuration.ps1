function Get-Configuration
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [string]
        $ConfigurationName
    )

    begin
    {
    }
    process
    {
        if( $PSBoundParameters.ContainsKey( "ConfigurationName" ) )
        {
            Get-DataTable -StoredProcedure "sitecertification.proc_GetSiteCertificationConfiguration" -Parameters @{ configurationName = $ConfigurationName } -As "PSObject" -ErrorAction Stop
        }
        else 
        {
            Get-DataTable -StoredProcedure "sitecertification.proc_GetSiteCertificationConfiguration" -As "PSObject" -ErrorAction Stop
        }
    }
    end
    {
    }
}