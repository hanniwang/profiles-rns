USE [ProfilesRNS]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Grant.AffiliatedPeople](
  [GrantID] [int] NOT NULL,
  [PersonID] [int] NULL,
  [SAPID] [varchar](8) NOT NULL,
  [IsPrincipalInvestigator] [bit] NULL)
GO
SET ANSI_PADDING OFF
GO