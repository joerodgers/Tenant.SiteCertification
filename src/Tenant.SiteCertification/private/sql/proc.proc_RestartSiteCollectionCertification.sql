CREATE OR ALTER PROCEDURE [sitecertification].[proc_RestartSiteCollectionCertification]
    @siteUrl nvarchar(500)
AS
BEGIN

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    UPDATE
        sitecertification.SiteCollection
    SET
        LastCertificationDate = @timestamp,
        LockDate              = null,
        LockState             = 0,
        NoticeCount           = 0,
        RowUpdated            = @timestamp
    WHERE
        SiteUrl = @siteUrl

    EXEC sitecertification.proc_AddSiteCollectionAuditEvent @siteUrl, 'SiteCertfication-SiteReset', @timestamp;

END
