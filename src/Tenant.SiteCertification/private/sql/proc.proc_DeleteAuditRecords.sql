CREATE OR ALTER PROCEDURE [sitecertification].[proc_DeleteAuditRecords]
	@datetime  date
AS
BEGIN
    
    DELETE FROM
        sitecertification.SiteCollectionAudit
    WHERE   
        RowCreated <= @datetime

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    EXEC [sitecertification].[proc_AddSiteCollectionAuditEvent] 'AuditLogRetention', 'AuditLog-LogTrimmed', @timestamp

END
