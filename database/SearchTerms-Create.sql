DROP PROCEDURE sp_SearchTerms;
DELIMITER ^^
CREATE PROCEDURE sp_SearchTerms( )
BEGIN
SELECT DISTINCT 'Skater' AS ColType, CONCAT(SkaterFirstName, " ", COALESCE(SkaterLastName,"")) AS ColValue, SkaterID as ColID FROM SkaterBios WHERE CONCAT(SkaterFirstName, " ", COALESCE(SkaterLastName,"")) != "NULL"
UNION
select DISTINCT 'Skater' AS ColType, SkaterAlias1 AS ColValue, SkaterID as ColID FROM SkaterBios WHERE SkaterAlias1 is not NULL 
UNION
SELECT DISTINCT "Park" AS ColType, Park AS ColValue, 0 AS ColID FROM SkatePix 
UNION 
SELECT DISTINCT "Trick" AS ColType, TrickName AS ColValue, 0 AS ColID FROM SkatePix
UNION
SELECT "MaxDate" AS ColType, DATE_FORMAT(MAX(DATE),"%y/%d/%Y"), 0 AS ColID FROM SkatePix
UNION
SELECT "MinDate" AS ColType, DATE_FORMAT(MIN(DATE),"%y/%d/%Y"), 0 AS ColID FROM SkatePix
UNION
SELECT DISTINCT "MediaType" AS ColType, MediaType AS ColValue, 0 AS ColID FROM SkatePix
ORDER BY ColType, ColValue; 
END^^
DELIMITER ;
