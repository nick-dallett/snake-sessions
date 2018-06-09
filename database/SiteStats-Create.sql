DROP PROCEDURE sp_SiteStats;
DELIMITER ^^
CREATE PROCEDURE sp_SiteStats( )
BEGIN
SELECT 'STATS', (SELECT CAST(COUNT(FileID) AS CHAR) FROM SkatePix WHERE MediaType = 'Video') as cVideos, (SELECT CAST(COUNT(FileID) AS CHAR) FROM SkatePix WHERE MediaType IN('Picture','Sequence')) AS cPictures, (SELECT CAST(COUNT(SkaterID) AS CHAR) FROM SkaterBios) AS cSkaters, 'DATE', 'PARK','MEDIA'
UNION
SELECT  'SESSION', ''/*cVideos*/,''/*cPictures*/,''/*cSkaters*/,DATE_FORMAT(Date,'%M %D, %Y'), Park, CAST(COUNT(FileID) AS CHAR) FROM SkatePix WHERE Park != '' AND Date != 0 GROUP BY Date, Park ORDER BY cVideos DESC LIMIT 5;
END^^
DELIMITER ;


 
