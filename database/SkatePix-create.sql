USE SnakeSessions



CREATE TABLE IF NOT EXISTS SkatePix(FileID INT NOT NULL AUTO_INCREMENT,HttpPath varchar(260) NOT NULL,HttpThumbPath varchar(260) NULL,LocalPath varchar(260) NOT NULL,FileName varchar(50) NOT NULL,ThumbName varchar(50) NULL,SkaterID int NULL,SkaterFirstName varchar(50) NULL,SkaterLastName varchar(50) NULL,Park varchar(50) NULL,Date datetime NULL,TrickName varchar(50) NULL,MediaType varchar(50) NULL,MediaSizeInBytes int NULL,SkaterAlias1 varchar(50) NULL,SkaterAlias2 varchar(50) NULL,Photographer varchar(50) NULL,Description varchar(255) NULL,layoutWidth int NOT NULL,YouTubeID varchar(50) NULL, PRIMARY KEY(FileID))

