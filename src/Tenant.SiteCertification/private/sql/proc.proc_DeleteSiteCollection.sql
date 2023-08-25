CREATE OR ALTER PROCEDURE [sitecertification].[proc_DeleteSiteCollection]
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
            SiteUrl
        FROM
            OPENJSON (@json, N'$') WITH 
            (
                SiteUrl nvarchar(500)
            )
        WHERE
            SiteUrl IS NOT NULL AND LEN(SiteUrl) > 0
    )

    -- delete matching SiteUrl from the json data in the SiteCollection table 
    MERGE INTO sitecertification.SiteCollection AS Existing
    USING cte AS New
    ON New.SiteUrl = Existing.SiteUrl
    WHEN MATCHED THEN
        DELETE
    OUTPUT $action AS 'EventType', Deleted.SiteUrl AS SiteUrl INTO #merged;

    DECLARE @cursor     cursor
    DECLARE @siteUrl    nvarchar(500)

    -- add an audit event for each row in the #merged table
    SET @cursor = CURSOR 
        FOR SELECT
            SiteUrl
        FROM
            #merged
    
    OPEN @cursor  

    FETCH NEXT FROM @cursor INTO @siteUrl;  

    WHILE @@fetch_status = 0
    BEGIN

        EXEC sitecertification.proc_AddSiteCollectionAuditEvent @siteUrl, 'SiteDeleted', @timestamp;
        
        FETCH next FROM @cursor INTO @siteUrl
    END
        
END