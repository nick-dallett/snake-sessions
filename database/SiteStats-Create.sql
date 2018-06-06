DROP PROCEDURE sp_SiteStats;
DELIMITER ^^
CREATE PROCEDURE sp_SiteStats( )
BEGIN
SELECT 'STATS', (SELECT COUNT(FileID) FROM SkatePix WHERE MediaType = 'Video') as cVideos, (SELECT COUNT(FileID) FROM SkatePix WHERE MediaType IN('Picture','Sequence')) AS cPictures, (SELECT COUNT(SkaterID) FROM SkaterBios) AS cSkaters, 'DATE', 'PARK','MEDIA'
UNION
SELECT  'SESSION', ''/*cVideos*/,''/*cPictures*/,''/*cSkaters*/,Date, Park, COUNT(FileID) FROM SkatePix WHERE Park != '' AND Date != 0 GROUP BY Date, Park ORDER BY cVideos DESC LIMIT 5;
END^^
DELIMITER ;


 
