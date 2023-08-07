IF (SCHEMA_ID('sitecertification') IS NULL) 
BEGIN
    EXEC ('CREATE SCHEMA [sitecertification]')
END
