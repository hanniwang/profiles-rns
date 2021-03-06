USE [ProfilesRNS]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Grant.Information](
  [GrantID] [int] IDENTITY(1,1) NOT NULL,
  [ARIAGrantID] [int] NULL,
  [ARIARecordID] [int] NULL,
  [StartDate] [datetime] NULL,
  [EndDate] [datetime] NULL,
  [GrantTitle] [varchar](1250) NULL,
  [GrantAbstract] [varchar](5000) NULL,
  [GrantAmount]  Numeric(18,0) NULL,  
  [SummaryXML] [xml] NULL,
  [IsActive] [bit] NULL
 PRIMARY KEY CLUSTERED 
(
  [GrantID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO