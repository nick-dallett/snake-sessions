USE [WebDB]
GO

/****** Object:  Table [dbo].[PixToBios]    Script Date: 10/22/2016 06:09:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PixToBios](
	[RelationID] [int] IDENTITY(1,1) NOT NULL,
	[fileid] [int] NOT NULL,
	[skaterid] [int] NOT NULL
) ON [PRIMARY]

GO

