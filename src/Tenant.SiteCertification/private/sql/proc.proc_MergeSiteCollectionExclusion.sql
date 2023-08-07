CREATE OR ALTER PROCEDURE [sitecertification].[proc_MergeSiteCollectionExclusion]
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
            RowCreated = @timestamp,
            RowUpdated = @timestamp
        FROM
            OPENJSON (@json, N'$') WITH 
            (
                SiteUrl nvarchar(500)
            )
    )

    -- merge the json data into the SiteCollection table and insert any inserted and deleted SiteUrl 
    -- values into the #merged table
    MERGE INTO sitecertification.SiteCollectionExclusion AS Existing
    USING cte AS New
    ON New.SiteUrl = Existing.SiteUrl
    WHEN MATCHED THEN -- row exists in SiteCollectionExclusion, just update RowUpdated timestamp
        UPDATE SET
            Existing.RowUpdated = New.RowUpdated
    WHEN NOT MATCHED BY TARGET THEN -- insert new records in SiteCollectionExclusion from the json data
        INSERT
        (
            SiteUrl,
            RowCreated,
            RowUpdated
        )
        VALUES
        (
            SiteUrl,
            RowCreated,
            RowUpdated
        )
    WHEN NOT MATCHED BY SOURCE THEN -- delete any records in SiteCollectionExclusion not in the json data
        DELETE
    OUTPUT $action AS 'EventType', COALESCE(Deleted.SiteUrl, Inserted.SiteUrl) AS SiteUrl INTO #merged;
   
    DECLARE @cursor     cursor
    DECLARE @siteUrl    nvarchar(500)
    DECLARE @auditEvent nvarchar(400)

    -- add an audit event for each row in the #merged table
    SET @cursor = CURSOR 
        FOR SELECT
            SiteUrl,
            CASE 
                WHEN EventType = 'INSERT' THEN 'SiteExclusion-SiteAdded'
                WHEN EventType = 'DELETE' THEN 'SiteExclusion-SiteDeleted'
                WHEN EventType = 'UPDATE' THEN 'SiteExclusion-SiteUpdated'
            END AS 'AuditEvent'
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

