IF OBJECT_ID('sitecertification.SiteCollectionConfiguration', 'U') IS NULL
BEGIN
    CREATE TABLE sitecertification.SiteCollectionConfiguration
    (
        ConfigurationName       nvarchar(500)     NOT NULL,
        ConfigurationValue      nvarchar(500)         NULL,
        RowCreated              datetime2(7)      NOT NULL,
        RowUpdated              datetime2(7)      NOT NULL,
        CONSTRAINT PK_SiteCollectionConfiguration_ConfigurationName PRIMARY KEY CLUSTERED (ConfigurationName ASC)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    INSERT INTO sitecertification.SiteCollectionConfiguration (ConfigurationName, ConfigurationValue, RowCreated, RowUpdated) VALUES ( 'VerificationIntervalDays',        '90', @timestamp, @timestamp)
    INSERT INTO sitecertification.SiteCollectionConfiguration (ConfigurationName, ConfigurationValue, RowCreated, RowUpdated) VALUES ( 'NotificationFrequencyDays',       '7',  @timestamp, @timestamp)
    INSERT INTO sitecertification.SiteCollectionConfiguration (ConfigurationName, ConfigurationValue, RowCreated, RowUpdated) VALUES ( 'NotificationsBeforeNoAccessLock', '6',  @timestamp, @timestamp)
    INSERT INTO sitecertification.SiteCollectionConfiguration (ConfigurationName, ConfigurationValue, RowCreated, RowUpdated) VALUES ( 'LockedDaysBeforeDeletion',        '45', @timestamp, @timestamp)

END