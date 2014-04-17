USE [ProfilesStaging]
GO

/****** Object:  StoredProcedure [Profile.Import].[Reload_Import_Tables]    Script Date: 04/17/2014 11:26:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Profile.Import].[Reload_Import_Tables]
AS
BEGIN
	DECLARE @SQLString0 NVARCHAR(MAX),
	@SQLString1 NVARCHAR(MAX),
	@SQLString2 NVARCHAR(MAX),
	@SQLString3 NVARCHAR(MAX),
	@SQLString4 NVARCHAR(MAX),
	@SQLString5 NVARCHAR(MAX);
	SET @SQLString0='truncate table [ProfilesRNS].[Profile.Import].[User]';
	SET @SQLString1='truncate table [ProfilesRNS].[Profile.Import].[Person]';
	SET @SQLString2='truncate table [ProfilesRNS].[Profile.Import].[PersonAffiliation]';
	SET @SQLString3='insert into  [ProfilesRNS].[Profile.Import].[User] select * from [ProfilesStaging].[Profile.Import].[User]';
	SET @SQLString4='insert into  [ProfilesRNS].[Profile.Import].[Person] select * from [ProfilesStaging].[Profile.Import].[Person]';
	SET @SQLString5='insert into  [ProfilesRNS].[Profile.Import].[PersonAffiliation] select * from [ProfilesStaging].[Profile.Import].[PersonAffiliation]';
	EXEC sp_executeSql @SQLString0;
	EXEC sp_executeSql @SQLString1;
	EXEC sp_executeSql @SQLString2;
	EXEC sp_executeSql @SQLString3;	
	EXEC sp_executeSql @SQLString4;
	EXEC sp_executeSql @SQLString5;
	update [ProfilesRNS].[Profile.Import].[PersonAffiliation] set departmentvisible='1' where departmentvisible is null;
	update [ProfilesRNS].[Profile.Import].[PersonAffiliation] set facultyrank='' where facultyrank is null;
	update [ProfilesRNS].[Profile.Import].[PersonAffiliation] set facultyrankorder='' where facultyrankorder is null;
END;


GO