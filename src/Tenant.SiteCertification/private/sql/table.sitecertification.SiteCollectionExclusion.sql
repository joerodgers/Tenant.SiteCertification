IF OBJECT_ID('sitecertification.SiteCollectionExclusion', 'U') IS NULL
BEGIN
    CREATE TABLE sitecertification.SiteCollectionExclusion
    (
        SiteUrl                 nvarchar(500)     NOT NULL,
        RowCreated              datetime2(7)      NOT NULL,
        RowUpdated              datetime2(7)      NOT NULL,
        CONSTRAINT PK_SiteCollectionExclusion_SiteUrl PRIMARY KEY CLUSTERED (SiteUrl ASC)
    )
END