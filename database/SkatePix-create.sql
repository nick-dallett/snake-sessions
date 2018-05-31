USE [WebDB]
GO

/****** Object:  Table [dbo].[SkatePix]    Script Date: 10/22/2016 06:10:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SkatePix](
	[FileID] [int] IDENTITY(1,1) NOT NULL,
	[HttpPath] [varchar](260) NOT NULL,
	[HttpThumbPath] [varchar](260) NULL,
	[LocalPath] [varchar](260) NOT NULL,
	[FileName] [varchar](50) NOT NULL,
	[ThumbName] [varchar](50) NULL,
	[SkaterID] [int] NULL,
	[SkaterFirstName] [varchar](50) NULL,
	[SkaterLastName] [varchar](50) NULL,
	[Park] [varchar](50) NULL,
	[Date] [datetime] NULL,
	[TrickName] [varchar](50) NULL,
	[MediaType] [varchar](50) NULL,
	[MediaSizeInBytes] [int] NULL,
	[SkaterAlias1] [varchar](50) NULL,
	[SkaterAlias2] [varchar](50) NULL,
	[Photographer] [varchar](50) NULL,
	[Description] [varchar](255) NULL,
	[layoutWidth] [int] NOT NULL,
	[YouTubeID] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[SkatePix] ADD  CONSTRAINT [DF_SkatePix_layoutWidth]  DEFAULT ((1)) FOR [layoutWidth]
GO

/*  MYSQL syntax

CREATE TABLE IF NOT EXISTS SkatePix(FileID INT NOT NULL AUTO_INCREMENT,HttpPath varchar(260) NOT NULL,HttpThumbPath [varchar](260) NULL,[LocalPath] [varchar](260) NOT NULL,[FileName] [varchar](50) NOT NULL,[ThumbName] [varchar](50) NULL,[SkaterID] [int] NULL,[SkaterFirstName] [varchar](50) NULL,[SkaterLastName] [varchar](50) NULL,[Park] [varchar](50) NULL,[Date] [datetime] NULL,[TrickName] [varchar](50) NULL,[MediaType] [varchar](50) NULL,[MediaSizeInBytes] [int] NULL,[SkaterAlias1] [varchar](50) NULL,[SkaterAlias2] [varchar](50) NULL,[Photographer] [varchar](50) NULL,[Description] [varchar](255) NULL,[layoutWidth] [int] NOT NULL,[YouTubeID] [varchar](50) NULL, PRIMARY KEY(FileID))



*/