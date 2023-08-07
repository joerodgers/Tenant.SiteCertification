CREATE OR ALTER PROCEDURE [sitecertification].[proc_MergeSiteCollection]
	@json nvarchar(max)
AS
BEGIN
    
    DECLARE @timestamp  datetime2(7) = GETUTCDATE()
    DECLARE @cursor     cursor
    DECLARE @siteUrl    nvarchar(500)
    DECLARE @auditEvent nvarchar(400)

    -- temp table for audit records
    CREATE TABLE #merged
    (
        EventType nvarchar(50),
        SiteUrl   nvarchar(500)
    )

    -- read the json string data into a cte table
    SET @cursor = CURSOR FOR
    
        WITH cte AS
        (
            SELECT
                SiteUrl,
                LockState
            FROM
                OPENJSON (@json, N'$') WITH 
                (
                    SiteUrl   nvarchar(500),
                    LockState nvarchar(10)
                )
            WHERE
                SiteUrl NOT IN (SELECT SiteUrl FROM sitecertification.SiteCollectionExclusion)
        )

        -- add an audit event for each SiteUrl that has change to the LockState
        
        SELECT
            cte.SiteUrl
        FROM
            sitecertification.SiteCollection sc,
            cte
        WHERE
            cte.SiteUrl = sc.SiteUrl AND 
            sc.LockState <> cte.LockState AND
            cte.LockState IS NOT NULL AND LEN(cte.LockState) > 0

        OPEN @cursor  

        FETCH NEXT FROM @cursor INTO @siteUrl;  

        WHILE @@fetch_status = 0
        BEGIN

            EXEC sitecertification.proc_AddSiteCollectionAuditEvent @siteUrl, 'SiteImport-LockStateChanaged', @timestamp;
            
            FETCH next FROM @cursor INTO @siteUrl;
        END
    ;


    -- read the json string data into a cte table
    ;WITH cte AS
    (
        SELECT
            SiteUrl,
            LockState,
            LockDate,
            NoticeCount,
            LastCertificationDate,
            Template,
            RowCreated = @timestamp,
            RowUpdated = @timestamp
        FROM
            OPENJSON (@json, N'$') WITH 
            (
                SiteUrl                 nvarchar(500),
                LockState               nvarchar(10),
                LockDate                datetime2(7),
                NoticeCount             int,
                LockedByExternalProcess bit,
                LastCertificationDate   datetime2(7),
                Template                nvarchar(50)
            )
        WHERE
            SiteUrl NOT IN (SELECT SiteUrl FROM sitecertification.SiteCollectionExclusion)
    )
    -- merge the json data into the SiteCollection table and insert any inserted and deleted SiteUrl 
    -- values into the #merged table
    MERGE INTO sitecertification.SiteCollection AS Existing
    USING cte AS New
    ON New.SiteUrl = Existing.SiteUrl
    WHEN MATCHED THEN
        UPDATE SET
            Existing.LockState             = ISNULL(New.LockState,             Existing.LockState ),
            Existing.LockDate              = ISNULL(New.LockDate,              Existing.LockDate ),
            Existing.LastCertificationDate = ISNULL(New.LastCertificationDate, Existing.LastCertificationDate),
            Existing.Template              = ISNULL(New.Template,              Existing.Template ),
            Existing.NoticeCount           = CASE WHEN Existing.LockState <> New.LockState THEN 0 ELSE ISNULL(New.NoticeCount, Existing.NoticeCount) END,
            Existing.RowUpdated            = New.RowUpdated
    WHEN NOT MATCHED BY TARGET THEN
        INSERT
        (
            SiteUrl,
            LockState,
            LockDate,
            NoticeCount,
            LastCertificationDate,
            Template,
            RowCreated,
            RowUpdated
        )
        VALUES
        (
            SiteUrl,
            LockState,
            LockDate,
            NoticeCount,
            LastCertificationDate,
            Template,
            RowCreated,
            RowUpdated
        )
    WHEN NOT MATCHED BY SOURCE THEN
        DELETE
    OUTPUT $action AS 'EventType', COALESCE(Deleted.SiteUrl, Inserted.SiteUrl) AS SiteUrl INTO #merged;

    -- add an audit event for each row in the #merged table
    SET @cursor = CURSOR 
        FOR SELECT
            SiteUrl,
            CASE 
                WHEN EventType = 'INSERT' THEN 'SiteImport-SiteAdded'
                WHEN EventType = 'DELETE' THEN 'SiteImport-SiteDeleted'
                WHEN EventType = 'UPDATE' THEN 'SiteImport-SiteUpdated'
            END AS 'AuditEvent'
        FROM
            #merged
        WHERE
            EventType IN ( 'INSERT', 'DELETE' )
    
    OPEN @cursor  

    FETCH NEXT FROM @cursor INTO @siteUrl, @auditEvent;  

    WHILE @@fetch_status = 0
    BEGIN

        EXEC sitecertification.proc_AddSiteCollectionAuditEvent @siteUrl, @auditEvent, @timestamp;
        
        FETCH next FROM @cursor INTO @siteUrl, @auditEvent;
    END

    -- trim audit log events >1 year
    DECLARE @datetime DATE = CAST((DATEADD(DAY, -366, @timestamp)) AS DATE)

    EXEC sitecertification.proc_DeleteAuditRecords @datetime
END
