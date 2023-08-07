CREATE OR ALTER PROCEDURE [sitecertification].[proc_AddSiteCollectionAuditEvent]
	@siteUrl        nvarchar(500),
    @auditEvent     nvarchar(400),
    @auditEventDate datetime2(7)
AS
BEGIN
    
    INSERT INTO sitecertification.SiteCollectionAudit
    (
        SiteUrl,
        AuditEvent,
        RowCreated
    )
    VALUES
    (
        @siteUrl,
        @auditEvent,
        @auditEventDate
    )

END
