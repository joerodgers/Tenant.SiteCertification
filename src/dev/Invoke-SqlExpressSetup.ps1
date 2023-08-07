
Import-Module -Name "C:\_projects\Tenant.SiteCertification\src\Tenant.SiteCertification\Tenant.SiteCertification.psd1" -Force -Verbose

$tc = New-SiteCertificationTenantConnection `
        -ClientId              $env:O365_CLIENTID `
        -CertificateThumbprint $env:O365_THUMBPRINT `
        -TenantName            "$($env:O365_TENANT).onmicrosoft.com" `
        -TenantId              $env:O365_TENANTID

$dc = New-SiteCertificationDatabaseConnection `
        -DatabaseName   "Tenant.SiteCertification" `
        -DatabaseServer "localhost\sqlexpress"

$cfg = New-SiteCertificationConfiguration `
        -ExecutionDate                   ([DateTime]::Today) `
        -VerificationIntervalDays        90 `
        -NotificationFrequencyDays       7 `
        -NotificationsBeforeNoAccessLock 6 `
        -LockedDaysBeforeDeletion        45 `
        -ErrorAction                     Stop   

Connect-SiteCertificationService `
        -DatabaseConnection $dc `
        -TenantConnection   $tc `
        -Configuration      $cfg `
        -ErrorAction        Stop
