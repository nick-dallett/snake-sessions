DROP PROCEDURE sp_getMatchingPictures;
DELIMITER ^^
CREATE PROCEDURE sp_getMatchingPictures(IN startDate DATETIME, IN endDate DATETIME, IN SkaterId INT, IN Park VARCHAR(50), IN Trick VARCHAR(50), IN MediaType VARCHAR(50), IN Unsorted BOOLEAN )
BEGIN

    DECLARE QueryString VARCHAR(500);
    DECLARE NeedsWhereClause BOOLEAN;
    DECLARE StartDateClause VARCHAR(50) DEFAULT NULL;
    DECLARE EndDateClause VARCHAR(50) DEFAULT NULL;
    DECLARE SkaterIDClause VARCHAR(50) DEFAULT NULL;
    DECLARE ParkClause VARCHAR(50) DEFAULT NULL;
    DECLARE TrickClause VARCHAR(50) DEFAULT NULL;
    DECLARE MediaTypeClause VARCHAR(50) DEFAULT NULL;

    SET NeedsWhereClause = StartDate IS NOT NULL || endDate  IS NOT NULL || SkaterID  IS NOT NULL || Park  IS NOT NULL || Trick IS NOT NULL || MediaType  IS NOT NULL;
        CASE
            WHEN Unsorted IS TRUE THEN
                SELECT * FROM SkatePix WHERE Date IS NULL;
            ELSE
                SET QueryString = "SELECT * FROM SkatePix";
                IF NeedsWhereClause THEN
                    SET QueryString = QueryString + " WHERE ";
                    IF (StartDate IS NOT NULL) THEN
                        SET StartDateClause = "Date >= '" + StartDate + "' AND ";
                    END IF
                    IF (EndDate IS NOT NULL) THEN
                        SET StartDateClause = "Date <= '" + EndDate + "' AND ";
                    END IF
                    IF (SkaterID IS NOT NULL) THEN
                        SET SkaterIDClause = "SkaterID = " + SkaterID + " AND ";
                    END IF
                    IF (Park IS NOT NULL) THEN
                        SET ParkClause = "Park = '" + Park + "' AND ";
                    END IF
                    IF (Trick IS NOT NULL) THEN
                        SET TrickClause = "Trickname = '" + Trick + "' AND ";
                    END IF
                    IF (MediaType IS NOT NULL) THEN
                        SET MediaTypeClause = "MediaType = '" + MediaType;
                    END IF
                    SET QueryString = CONCAT(QueryString,StartDateClause,EndDateClause,SkaterIDClause,ParkClause,TrickClause,MediaTypeClause," ORDER BY Date ASC");
                    IF SUBSTRING(QueryString,-5) = " AND " THEN
                        QueryString = SUBSTRING(QueryString, -5);
                    END IF
                END IF;
                PREPARE QS from QueryString;
                EXECUTE QS;
                DEALLOCATE PREPARE QS;
        END CASE;
END^^
DELIMITER ;
