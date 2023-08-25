

--- SET FAKE CERTIFICATION DATA FOR SITE NOTICES 

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
        SiteUrl IN ( 'https://contoso.sharepoint.com/sites/ae2ff014-8887-4620-be32-dd536c1aa464', 'https://contoso.sharepoint.com/sites/cd73ce94-22ea-4e5a-bc51-d0e4c25960b6', 'https://contoso.sharepoint.com/sites/98d9046f-7227-4d57-83ec-d58be7d1b053' )
    
    --- EXEC PROC

    DECLARE @datetime date = GETUTCDATE()

    EXECUTE [sitecertification].[proc_GetSiteCollectionsForNotification] @today



--- SET FAKE CERTIFICATION DATA FOR SITE NO ACCESS LOCK 

    DECLARE @today date = GETDATE()

    DECLARE @lastCertificationDate DATETIME2(0) = DATEADD(DAY, -90, @today)

    UPDATE 
        sitecertification.SiteCollection
    SET
        LockState             = 0,
        LockDate              = NULL,
        NoticeCount           = 6,
        LastCertificationDate = @lastCertificationDate
    WHERE
        SiteUrl IN ( 'https://contoso.sharepoint.com/sites/ae2ff014-8887-4620-be32-dd536c1aa464', 'https://contoso.sharepoint.com/sites/cd73ce94-22ea-4e5a-bc51-d0e4c25960b6', 'https://contoso.sharepoint.com/sites/98d9046f-7227-4d57-83ec-d58be7d1b053' )

    --- EXEC PROC

    DECLARE @datetime date = GETUTCDATE()

    EXECUTE [sitecertification].[proc_GetSiteCollectionsForNoAccessLock] @today


--- SET FAKE CERTIFICATION DATA FOR SITE DELETION 

    DECLARE @today date = GETDATE()

    DECLARE @lastCertificationDate DATETIME2(0) = DATEADD(DAY, -90, @today)

    UPDATE 
        sitecertification.SiteCollection
    SET
        LockState             = 2,
        LockDate              = @lastCertificationDate,
        NoticeCount           = 6,
        LastCertificationDate = @lastCertificationDate
    WHERE
        SiteUrl IN ( 'https://contoso.sharepoint.com/sites/ae2ff014-8887-4620-be32-dd536c1aa464', 'https://contoso.sharepoint.com/sites/cd73ce94-22ea-4e5a-bc51-d0e4c25960b6', 'https://contoso.sharepoint.com/sites/98d9046f-7227-4d57-83ec-d58be7d1b053' )

    --- EXEC PROC

    DECLARE @datetime date = GETUTCDATE()

    EXECUTE [sitecertification].[proc_GetSiteCollectionsForDeletion] @today