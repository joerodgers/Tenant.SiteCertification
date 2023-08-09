CREATE OR ALTER PROCEDURE [sitecertification].[proc_GetSiteCertificationConfiguration]
    @configurationName nvarchar(500) = null
AS
BEGIN

    IF( @configurationName IS NOT NULL AND LEN(TRIM(@configurationName)) > 0)

        SELECT
            *
        FROM
            sitecertification.SiteCollectionConfiguration
        WHERE
            ConfigurationName = @configurationName

    ELSE

        SELECT
            *
        FROM
            sitecertification.SiteCollectionConfiguration

END