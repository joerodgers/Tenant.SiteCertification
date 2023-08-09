CREATE OR ALTER PROCEDURE [sitecertification].[proc_GetSiteCertificationConfigurationValue]
    @configurationName nvarchar(500)
AS
BEGIN

    DECLARE @ConfigurationValue nvarchar(500)
    
    SELECT
        @ConfigurationValue = ConfigurationValue
    FROM
        sitecertification.SiteCollectionConfiguration
    WHERE
        ConfigurationName = @configurationName

    return @ConfigurationValue
END