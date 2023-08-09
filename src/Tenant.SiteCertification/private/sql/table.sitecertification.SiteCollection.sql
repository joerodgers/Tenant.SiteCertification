IF OBJECT_ID('sitecertification.SiteCollection', 'U') IS NULL
BEGIN
    CREATE TABLE sitecertification.SiteCollection
    (
        SiteUrl                 nvarchar(500)     NOT NULL,
        LockState               tinyint           NOT NULL,
        LockDate                date,
        NoticeCount             tinyint           NOT NULL,
        LastCertificationDate   date              NOT NULL,
        Template                nvarchar(50 )     NOT NULL,
        RowCreated              datetime2(7)      NOT NULL,
        RowUpdated              datetime2(7)      NOT NULL,
        CONSTRAINT PK_SiteCollection_SiteUrl PRIMARY KEY CLUSTERED (SiteUrl ASC)
    )
END
