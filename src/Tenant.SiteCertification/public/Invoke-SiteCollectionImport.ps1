function Invoke-SiteCollectionImport
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string[]]
        $Template,

        [Parameter(Mandatory=$false)]
        [int]
        $BatchSize = 10000
    )

    begin
    {
        $tenantSites = New-Object System.Collections.Generic.List[Tenant.SiteCertification.TenantSite] 

        $excludedTemplates = "EDISC#0", "APPCATALOG#0", "RedirectSite#0", "SPSMSITEHOST#0", "POINTPUBLISHINGHUB#0", "POINTPUBLISHINGPERSONAL#0", "POINTPUBLISHINGTOPIC#0"
    }
    process
    {
        Assert-ServiceConnection -Cmdlet $PSCmdlet

        Assert-SharePointConnection -Cmdlet $PSCmdlet

        $siteCollections = Get-PnPTenantSite -GroupIdDefined $false -ErrorAction Stop

        # filter out all sites that are mandator
        $siteCollections = [System.Linq.Enumerable]::ToList( $siteCollections.Where( { $excludedTemplates -notcontains $_.Template } ) )

        # filter out all sites that don't match our current list
        # $siteCollections = [System.Linq.Enumerable]::ToList( $siteCollections.Where( { $Template -contains $_.Template } ) )

        foreach( $siteCollection in $siteCollections )
        {
            if( $siteCollection.GroupId -ne [Guid]::Empty )
            {
                continue # just a double check to not process M365 group enabled sites
            }

            $ts = New-Object Tenant.SiteCertification.TenantSite
            $ts.SiteUrl               = $siteCollection.Url
            $ts.Template              = $siteCollection.Template
            $ts.LastCertificationDate = [DateTime]::Today
            $ts.LockState             = $siteCollection.LockState
            $ts.LockDate              = $siteCollection.LockState -ne "Unlock" ? [DateTime]::Today : $null

            $tenantSites.Add($ts)
        }
        
        $json = $tenantSites | ConvertTo-Json -Compress -AsArray 

        Invoke-StoredProcedure -StoredProcedure "sitecertification.proc_MergeSiteCollection" -Parameters @{ json =  $json }

    }
    end
    {
    }
}