USE [WebDB]
GO

/****** Object:  Table [dbo].[SkaterBios]    Script Date: 10/22/2016 06:10:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SkaterBios](
	[SkaterID] [int] IDENTITY(1,1) NOT NULL,
	[SkaterFirstName] [varchar](50) NULL,
	[SkaterLastName] [varchar](50) NULL,
	[SkaterAlias1] [varchar](50) NULL,
	[SkaterAlias2] [varchar](50) NULL,
	[Bio] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

