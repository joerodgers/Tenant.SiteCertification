CREATE OR ALTER PROCEDURE [sitecertification].[proc_GetLockedSiteCollection]
	@datetime datetime2(7)
AS
BEGIN

    SELECT
        *
    FROM
        sitecertification.SiteCollection
    WHERE
        LockState = 2 AND LockDate <= @datetime
END