function Invoke-SiteCollectionImport
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [int]
        $BatchSize = 10000
    )

    begin
    {
        $tenantSites = New-Object System.Collections.Generic.List[Tenant.SiteCertification.TenantSite] 

        $excludedTemplates = "EDISC#0", 
                             "APPCATALOG#0", 
                             "RedirectSite#0", 
                             "SPSMSITEHOST#0", 
                             "POINTPUBLISHINGHUB#0", 
                             "POINTPUBLISHINGPERSONAL#0",
                             "POINTPUBLISHINGTOPIC#0",
                             "GROUP#0",
                             "TEAMCHANNEL#0",
                             "TEAMCHANNEL#1"
    }
    process
    {
        Assert-ServiceConnection -Cmdlet $PSCmdlet

        Assert-SharePointConnection -Cmdlet $PSCmdlet

        Write-PSFMessage -Message "Querying tenant for non-group connected sites." -Level Verbose  
        
        # query tenant to pull all non-group connected sites
        $siteCollections = Get-PnPTenantSite -GroupIdDefined $false -ErrorAction Stop

        Write-PSFMessage -Message "Discovered $($siteCollections.Count) non-group connected sites." -Level Verbose  

        # filter out all sites that are mandatory exclusions
        $siteCollections = [System.Linq.Enumerable]::ToList( $siteCollections.Where( { $excludedTemplates -notcontains $_.Template } ) )

        # remove any and all od4b sites
        $siteCollections = [System.Linq.Enumerable]::ToList( $siteCollections.Where( { $_.Template -notmatch "^SPSPERS" } ) )

        Write-PSFMessage -Message "Removing sites using templates; $($excludedTemplates -join ',')." -Level Verbose  

        Write-PSFMessage -Message "Filtered out sites by template to $($siteCollections.Count) sites." -Level Verbose  

        foreach( $siteCollection in $siteCollections )
        {
            if( $siteCollection.GroupId -ne [Guid]::Empty )
            {
                continue # just a double check to not process M365 group enabled sites
            }

            if( [Uri]::new( $siteCollection.Url ).AbsolutePath -eq "/" )
            {
                Write-PSFMessage -Message "Skipping root site $($siteCollection.Url)." -Level Verbose  
                continue # just a double check to not process any rootsite
            }

            if( [Uri]::new( $siteCollection.Url ).AbsolutePath -eq "/search" )
            {
                Write-PSFMessage -Message "Skipping search site $($siteCollection.Url)." -Level Verbose
                continue # just a double check to not process tenant search center
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

        Invoke-StoredProcedure -StoredProcedure "sitecertification.proc_MergeSiteCollection" -Parameters @{ json =  $json } -CommandTimeout 300
    }
    end
    {
    }
}