CREATE OR ALTER PROCEDURE [sitecertification].[proc_DropSiteCertificationStoredProcedures]
AS
BEGIN

    DECLARE @sql nvarchar(max) = ''

    SELECT
        @sql = @sql + 'DROP PROCEDURE [' + SCHEMA_NAME(p.schema_id) + '].[' + p.NAME + '];' 
    FROM
        sys.procedures p 
    WHERE 
        SCHEMA_NAME(p.schema_id) = 'sitecertification' AND p.NAME <> 'proc_DropSiteCertificationStoredProcedures'

    EXEC (@sql)

END
