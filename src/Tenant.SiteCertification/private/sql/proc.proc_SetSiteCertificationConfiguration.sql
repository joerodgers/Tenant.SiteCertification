CREATE OR ALTER PROCEDURE [sitecertification].[proc_SetSiteCertificationConfiguration]
    @configurationName  nvarchar(500),
    @configurationValue nvarchar(500)
AS
BEGIN

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    IF NOT EXISTS( SELECT 1 FROM sitecertification.SiteCollectionConfiguration WHERE ConfigurationName = @configurationName )
    BEGIN

        INSERT INTO sitecertification.SiteCollectionConfiguration
        (
            ConfigurationName,
            ConfigurationValue,
            RowCreated,
            RowUpdated
        )
        VALUES
        (
            @configurationName,
            @configurationValue,
            @timestamp,
            @timestamp
        )

        EXEC sitecertification.proc_AddSiteCollectionAuditEvent 'Configuration', 'ConfigurationAdded', @timestamp;
    
    END
    ELSE
    BEGIN

        UPDATE 
            sitecertification.SiteCollectionConfiguration
        SET
            ConfigurationValue = @configurationValue,
            RowUpdated         = @timestamp
        WHERE
            ConfigurationName = @configurationName

        EXEC sitecertification.proc_AddSiteCollectionAuditEvent 'Configuration', 'ConfigurationUpdated', @timestamp;

    END
END
