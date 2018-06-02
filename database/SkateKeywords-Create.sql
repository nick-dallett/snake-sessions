USE SnakeSessions

CREATE TABLE SkateKeywords(Keyword_ID int NOT NULL AUTO_INCREMENT,Keyword nvarchar(255) NOT NULL,Column varchar(50) NOT NULL,DisplayName nvarchar(50) NOT NULL,SkaterID int NULL, PRIMARY KEY (Keyword_ID), UNIQUE(Keyword, Column, DisplayName)

