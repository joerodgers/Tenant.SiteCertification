﻿CREATE OR ALTER PROCEDURE [sitecertification].[proc_GetSiteCollectionsForNoAccessLock]
    @datetime DATETIME2(0)
AS
BEGIN

    DECLARE @notificationsBeforeNoAccessLock INT
    DECLARE @verificationIntervalDays        INT
    DECLARE @notificationFrequencyDays       INT

    EXEC @notificationsBeforeNoAccessLock = sitecertification.proc_GetSiteCertificationConfigurationValue 'NotificationsBeforeNoAccessLock'
    EXEC @verificationIntervalDays        = sitecertification.proc_GetSiteCertificationConfigurationValue 'VerificationIntervalDays'
    EXEC @notificationFrequencyDays       = sitecertification.proc_GetSiteCertificationConfigurationValue 'NotificationFrequencyDays'
    
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
        NoticeCount >= @notificationsBeforeNoAccessLock AND
        ((ABS(DATEDIFF(DAY, @datetime, LastCertificationDate)) - @verificationIntervalDays) % @notificationFrequencyDays) = 0

END
