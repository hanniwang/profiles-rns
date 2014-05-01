USE [ProfilesStaging]
GO

/****** Object:  StoredProcedure [Profile.Import].[Reload_All]    Script Date: 04/17/2014 11:06:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Profile.Import].[Reload_All]
AS
BEGIN	
	EXEC  [ProfilesStaging].[Profile.Import].[Backup_Import_Tables];
	EXEC  [ProfilesStaging].[Profile.Import].[SCHOLAR_T32];
	EXEC  [ProfilesStaging].[Profile.Import].[Import_SAP_Data];
	EXEC  [ProfilesStaging].[Profile.Import].[Reload_Import_Tables];
END;
GO
