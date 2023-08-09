CREATE OR ALTER PROCEDURE [sitecertification].[proc_GetSiteCollectionsForDeletion]
    @datetime DATETIME2(0)
AS
BEGIN

    DECLARE @notificationsBeforeNoAccessLock INT

    EXEC @notificationsBeforeNoAccessLock = sitecertification.proc_GetSiteCertificationConfigurationValue 'NotificationsBeforeNoAccessLock'

    SELECT
        SiteUrl,
        LockState,
        LockDate,
        NoticeCount,
        LastCertificationDate,
        Template
    FROM
        sitecertification.SiteCollection
    WHERE   
        SiteUrl NOT IN (SELECT SiteUrl FROM sitecertification.SiteCollectionExclusion) AND
        LockState = 2 AND 
        NoticeCount >= @notificationsBeforeNoAccessLock AND 
        LockDate <= @datetime

END
