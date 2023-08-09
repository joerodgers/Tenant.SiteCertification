

--- SET FAKE CERTIFICATION DATA

    DECLARE @today date = GETDATE()

    DECLARE @lastCertificationDate DATETIME2(0) = DATEADD(DAY, -90, @today)

    UPDATE 
        sitecertification.SiteCollection
    SET
        LockState             = 0,
        LockDate              = NULL,
        NoticeCount           = 0,
        LastCertificationDate = @lastCertificationDate
    WHERE
        SiteUrl IN ( 'https://contoso.sharepoint.com/sites/teamsite', 'https://contoso.sharepoint.com/sites/teamsite1', 'https://contoso.sharepoint.com/sites/teamsite2' )
    
--- EXEC PROC CALL

    DECLARE @datetime date = GETUTCDATE()

    EXECUTE [sitecertification].[proc_GetSiteCollectionsForNotification] @today

