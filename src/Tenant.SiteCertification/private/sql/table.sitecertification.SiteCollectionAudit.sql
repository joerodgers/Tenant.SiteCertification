IF OBJECT_ID('sitecertification.SiteCollectionAudit', 'U') IS NULL
BEGIN
    CREATE TABLE sitecertification.SiteCollectionAudit
    (
        Id         int            IDENTITY(1,1),
        SiteUrl    nvarchar(500)  NOT NULL,
        AuditEvent nvarchar(400)  NOT NULL,
        RowCreated datetime2(2)   NOT NULL
    )

    CREATE INDEX IX_SiteCollectionAudit_SiteUrl ON sitecertification.SiteCollectionAudit (SiteUrl);
END
