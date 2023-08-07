
Import-Module -Name "C:\_projects\Tenant.SiteCertification\src\Tenant.SiteCertification\Tenant.SiteCertification.psd1" -Force -Verbose

$tc = New-SiteCertificationTenantConnection `
        -ClientId              $env:O365_CLIENTID `
        -CertificateThumbprint $env:O365_THUMBPRINT `
        -TenantName            "$($env:O365_TENANT).onmicrosoft.com" `
        -TenantId              $env:O365_TENANTID

$dc = New-SiteCertificationDatabaseConnection `
        -DatabaseName          "sql-dataconnect" `
        -DatabaseServer        "srv-dataconnect.database.windows.net" `
        -ClientId              "a5f805f0-6c3c-483e-9bb8-53c65ea299e1" `
        -CertificateThumbprint $env:O365_THUMBPRINT `
        -TenantId              "ef74271e-fef6-44f2-802c-7142413a35c6"

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
