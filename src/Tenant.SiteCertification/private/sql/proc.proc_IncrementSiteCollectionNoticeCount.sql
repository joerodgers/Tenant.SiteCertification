CREATE OR ALTER PROCEDURE [sitecertification].[proc_IncrementSiteCollectionNoticeCount]
    @json nvarchar(max)
AS
BEGIN

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    -- temp table for audit records
    CREATE TABLE #merged
    (
        EventType nvarchar(50),
        SiteUrl   nvarchar(500)
    );

    -- read the json string data into a cte table
    ;WITH cte AS
    (
        SELECT
            SiteUrl,
            RowUpdated = @timestamp
        FROM
            OPENJSON (@json, N'$') WITH 
            (
                SiteUrl nvarchar(500)
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
            Existing.NoticeCount = Existing.NoticeCount + 1,
            Existing.RowUpdated  = New.RowUpdated
    OUTPUT $action AS 'EventType', COALESCE( Inserted.SiteUrl, Deleted.SiteUrl ) AS SiteUrl INTO #merged;

    DECLARE @cursor     cursor
    DECLARE @siteUrl    nvarchar(500)
    DECLARE @auditEvent nvarchar(400)

    -- add an audit event for each row in the #merged table
    SET @cursor = CURSOR 
        FOR SELECT
            SiteUrl,
            'SiteCertification-NoticeCountIncremented' AS 'AuditEvent'
        FROM
            #merged
    
    OPEN @cursor  

    FETCH NEXT FROM @cursor INTO @siteUrl, @auditEvent;  

    WHILE @@fetch_status = 0
    BEGIN

        EXEC sitecertification.proc_AddSiteCollectionAuditEvent @siteUrl, @auditEvent, @timestamp;
        
        FETCH next FROM @cursor INTO @siteUrl, @auditEvent;
    END

END
