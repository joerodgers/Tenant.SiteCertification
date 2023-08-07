CREATE OR ALTER PROCEDURE [sitecertification].[proc_SetSiteCollectionNoAccess]
    @siteUrl nvarchar(500),
    @date    date
AS
BEGIN

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    UPDATE
        sitecertification.SiteCollection
    SET
        LockDate   = @date,
        LockState  = 1,
        RowUpdated = @timestamp
    WHERE
        SiteUrl = @siteUrl

    EXEC sitecertification.proc_AddSiteCollectionAuditEvent @siteUrl, 'SiteCertfication-SiteLockedNoAccess', @timestamp;

END
