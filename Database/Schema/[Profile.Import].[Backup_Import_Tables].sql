USE [ProfilesStaging]
GO

/****** Object:  StoredProcedure [Profile.Import].[Backup_Import_Tables]    Script Date: 04/17/2014 11:22:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Profile.Import].[Backup_Import_Tables]
AS	
  BEGIN
	declare @datestamp varchar(50);
	DECLARE @SQLString1 NVARCHAR(MAX),
	@SQLString2 NVARCHAR(MAX),
	@SQLString3 NVARCHAR(MAX);
	--select @datestamp='_'+CONVERT(VARCHAR(25),GETDATE(),112)
	select @datestamp='_'+replace(replace(replace(CONVERT(VARCHAR(19),GETDATE(),126),'-',''),':',''),'T','_')
	SET @SQLString1 = 'select * into [ProfilesStaging].[Profile.Import].[User'+  @datestamp + '] FROM [ProfilesRNS].[Profile.Import].[User];'
	SET @SQLString2 = 'select * into [ProfilesStaging].[Profile.Import].[Person'+  @datestamp + '] FROM [ProfilesRNS].[Profile.Import].[Person];'
	SET @SQLString3 = 'select * into [ProfilesStaging].[Profile.Import].[PersonAffiliation'+  @datestamp + '] FROM [ProfilesRNS].[Profile.Import].[PersonAffiliation];'
	--PRINT @SQLString1;
	--PRINT @SQLString2;
	--PRINT @SQLString3;
	EXEC sp_executeSql @SQLString1;
	EXEC sp_executeSql @SQLString2;
	EXEC sp_executeSql @SQLString3;
  END;



GO
