USE [WebDB]
GO

/****** Object:  Table [dbo].[SkateKeywords]    Script Date: 10/22/2016 06:09:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SkateKeywords](
	[Keyword_ID] [int] IDENTITY(1,1) NOT NULL,
	[Keyword] [nvarchar](255) NOT NULL,
	[Column] [varchar](50) NOT NULL,
	[DisplayName] [nvarchar](50) NOT NULL,
	[SkaterID] [int] NULL,
 CONSTRAINT [PK_SkateKeywords_1] PRIMARY KEY CLUSTERED 
(
	[Keyword] ASC,
	[Column] ASC,
	[DisplayName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[SkateKeywords] ADD  CONSTRAINT [DF_SkateKeywords_DisplayName]  DEFAULT (N' ') FOR [DisplayName]
GO

