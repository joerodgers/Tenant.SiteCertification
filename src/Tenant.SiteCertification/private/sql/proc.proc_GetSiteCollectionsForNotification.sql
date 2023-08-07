CREATE OR ALTER PROCEDURE [sitecertification].[proc_GetSiteCollectionsForNotification]
    @datetime                        DATETIME2(0),
    @notificationsBeforeNoAccessLock INT,
    @verificationIntervalDays        INT,
    @notificationFrequencyDays       INT
AS
BEGIN

    SELECT
        SiteUrl,
        LockState,
        LockDate,
        NoticeCount,
        LastCertificationDate,
        Template,
        ABS( DATEDIFF(DAY, @datetime, LastCertificationDate)) AS 'DaysSinceLastCertificationDate'
    FROM
        sitecertification.SiteCollection
    WHERE   
        SiteUrl NOT IN (SELECT SiteUrl FROM sitecertification.SiteCollectionExclusion) AND
        LockState = 0 AND
        NoticeCount <= @notificationsBeforeNoAccessLock AND
        ((ABS( DATEDIFF(DAY, @datetime, LastCertificationDate)) - @verificationIntervalDays) % @notificationFrequencyDays) = 0 AND
        LastCertificationDate <= @datetime

END
