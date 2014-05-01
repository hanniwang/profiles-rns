USE [ProfilesStaging]
GO

/****** Object:  StoredProcedure [Profile.Import].[Import_SAP_Data]    Script Date: 05/01/2014 10:58:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Profile.Import].[Import_SAP_Data]
AS
BEGIN
	DECLARE @SQLString0 NVARCHAR(MAX),
	@SQLString1 NVARCHAR(MAX),
	@SQLString2 NVARCHAR(MAX),
	@SQLString3 NVARCHAR(MAX);
	SET @SQLString0='truncate table [ProfilesStaging].[Profile.Import].[Person]';
	SET @SQLString1='truncate table [ProfilesStaging].[Profile.Import].[PersonAffiliation]';
	SET @SQLString2='truncate table [ProfilesStaging].dbo.[non_tri]';
	SET @SQLString3='truncate table [ProfilesStaging].[Profile.Import].[User]';
	EXEC sp_executeSql @SQLString0;
	EXEC sp_executeSql @SQLString1;
	EXEC sp_executeSql @SQLString2;
	EXEC sp_executeSql @SQLString3;	

	insert into [Profile.Import].[Person] 
	select * From [ProfilesStaging].[Profile.Import].[Person_T32];

	insert 
	into [Profile.Import].[Person] 
	select cast(CAST(A.SAPID as int) as varchar),
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.FirstName), 
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.MiddleName), 
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.LastName), 
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.FirstName) + ' ' + [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.LastName), 
		   null, 
		   A.Address1,
		   A.Address2,
		   'Mail Slot # ' + CASE WHEN LTRIM(RTRIM(A.Slot))='' THEN NULL ELSE LTRIM(RTRIM(A.Slot)) END,
		   null, 
		   (case when (A.Address2 like '%location%' or A.Address2 like '%various%') then null else LTRIM(RTRIM(A.Address2)) + ' ' + LTRIM(RTRIM(A.City)) + ' ' + LTRIM(RTRIM(A.State)) + ' ' +  LTRIM(RTRIM(A.Zip)) end),
		   A.City,
		   A.State, 
		   A.Zip,
		   A.Building, 
		   A.Room,
		   null,
		   null, 
		   null,
		   (case 
			when LTRIM(RTRIM(ISNULL(A.Workphone,'')))='' OR LTRIM(RTRIM(ISNULL(A.Workphone,''))) like '%00000%' OR LTRIM(RTRIM(ISNULL(A.Workphone,''))) like '%9999%' then ''
			when LEN(A.Workphone) > 10 then 
				case 
					when A.Workphone not like '%-%' then SUBSTRING(A.Workphone, 1, 3) + '-' + SUBSTRING(A.Workphone, 4, 3) + '-' + SUBSTRING(A.Workphone, 7,4) + ' x' + SUBSTRING(A.Workphone, 11,4)
					else A.Workphone
				end	
			when LEN(A.Workphone) < 10 then
				case 
					when (LTRIM(RTRIM(ISNULL(A.Workphone,''))) like '686%' OR (LTRIM(RTRIM(ISNULL(A.Workphone,''))) like '526%')) then '501-' + SUBSTRING(A.Workphone, 1, 3) + '-' + SUBSTRING(A.Workphone, 4, 4)
					else ''
				end
			else 
				case 
					when A.Workphone not like '%-%' then SUBSTRING(A.Workphone, 1, 3) + '-' + SUBSTRING(A.Workphone, 4, 3) + '-' + SUBSTRING(A.Workphone,7,4)
					else A.Workphone
				end
		   end),
		   (case
			when LTRIM(RTRIM(ISNULL(A.Faxnum,'')))='' OR LTRIM(RTRIM(ISNULL(A.Faxnum,''))) like '%00000%' OR LTRIM(RTRIM(ISNULL(A.Faxnum,''))) like '%9999%' then ''
			when LEN(A.Faxnum) > 10 then 
				case 
					when A.Faxnum not like '%-%' then SUBSTRING(A.Faxnum, 1, 3) + '-' + SUBSTRING(A.Faxnum, 4, 3) + '-' + SUBSTRING(A.Faxnum, 7,4) + ' x' + SUBSTRING(A.Faxnum, 11,4)
					else A.Faxnum
				end	
			when LEN(A.Faxnum) < 10 then
				case 
					when (LTRIM(RTRIM(ISNULL(A.Faxnum,''))) like '686%' OR (LTRIM(RTRIM(ISNULL(A.Faxnum,''))) like '526%')) then '501-' + SUBSTRING(A.Faxnum, 1, 3) + '-' + SUBSTRING(A.Faxnum, 4, 4)
					else ''
				end
			else 
				case 
					when A.Faxnum not like '%-%' then SUBSTRING(A.Faxnum, 1, 3) + '-' + SUBSTRING(A.Faxnum, 4, 3) + '-' + SUBSTRING(A.Faxnum,7,4)
					else A.Faxnum
				end
		   end),
		   LTRIM(RTRIM(ISNULL(A.EmailAddress,''))),
		   '1',
		   '1'
	From (select	(case when X.SAPID is null then Y.ZTXTSAPID else X.SAPID end) SAPID,
			(case when X.LastName is null then Y.ZTXTLNAME else X.LastName end) LastName,
			(case when X.FirstName is null then Y.ZTXTFNAME else X.FirstName end) FirstName,
			(case when X.MiddleName is null then Y.ZTXTMNAME else X.MiddleName end) MiddleName,
			(case when X.Gender is null then Y.ZGENDER else X.Gender end) Gender,
			(case when (X.EmailAddress is null OR LTRIM(RTRIM(X.EmailAddress))='') then Y.ZTXTEMAILADDRESS else X.EmailAddress end) EmailAddress,
			(case when X.Workphone is null then Y.ZTXTPHONE1 else X.Workphone end) Workphone,
			(case when X.Department is null then null else X.Department end) Department,
			(case when X.Slot is null then Y.ZTXTMAILSLOT else X.Slot end) Slot,
			(case when X.Room is null then Y.ZTXTWORKLOCATION else X.Room end) Room,
			(case when X.Building is null then Y.ZTXTBUILDING else X.Building end) Building,
			(case when X.faxnum is null then null else X.faxnum end) faxnum,
			(case when X.title is null then Y.ZTXTPOSDESCRIPT else X.title end) title,
			(case when (X.Room is null or X.Building is null) then (Y.ZTXTWORKLOCATION + (CASE WHEN LTRIM(RTRIM(ISNULL(Y.ZTXTWORKLOCATION,''))) ='' THEN '' ELSE ' ' END) + LTRIM(RTRIM(Y.ZTXTBUILDING))) else (X.Room + (CASE WHEN LTRIM(RTRIM(ISNULL(X.Room,''))) ='' THEN '' ELSE ' ' END) + LTRIM(RTRIM(X.Building))) end) Address1,
			(case when X.Address1 is null then (CASE WHEN LTRIM(RTRIM(Y.ZTXTBUILDING)) like '%University Tower%' THEN '1123 S University Ave.' ELSE '4301 W Markham St.' END) else X.Address1 end) Address2,
			(case when X.City is null then 'Little Rock' else X.City end) City,
			(case when X.State is null then 'AR' else X.State end) State,
			(case when X.Zip is null then (CASE WHEN LTRIM(RTRIM(Y.ZTXTBUILDING)) like '%University Tower%' THEN '72204' ELSE '72205' END) else X.Zip end) Zip
		FROM [HOSP_SQL1].[FacFac].[dbo].[vTRI_SAPFaculty] X
		full outer join [DevDataRepo].[dbo].[ZHRSEC] Y on X.SAPID=Y.ZTXTSAPID) A
	inner join [HOSP_SQL1].[FacFac].[dbo].[vTRI_Appointments] B 
	ON A.SAPID=B.SAPID
	where B.IsPrimaryAppointment='1';

	with X as (
	select ROW_NUMBER() over (partition by Z.SAPID order by Z.SAPID, Z.DepartmentName desc) as RN, Z.* from 
	(select * From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Appointments] where IsPrimaryAppointment='1') Y
	right outer join 
	(select * From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Appointments] where IsPrimaryAppointment='0') Z
	on Y.SAPID=Z.SAPID where Y.SAPID is null and Z.SAPID is not null) insert into non_tri select * From X where RN =1;

	INSERT INTO [Profile.Import].Person
	select cast(CAST(A.SAPID as int) as varchar),
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.FirstName), 
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.MiddleName), 
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.LastName), 
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.FirstName) + ' ' + [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.LastName),
		   null, 
		   A.Address1,
		   A.Address2,
		   'Mail Slot # ' + CASE WHEN LTRIM(RTRIM(A.Slot))='' THEN NULL ELSE LTRIM(RTRIM(A.Slot)) END,
		   null, 
		   (case when (A.Address2 like '%location%' or A.Address2 like '%various%') then null else LTRIM(RTRIM(A.Address2)) + ' ' + LTRIM(RTRIM(A.City)) + ' ' + LTRIM(RTRIM(A.State)) + ' ' +  LTRIM(RTRIM(A.Zip)) end),
		   A.City,
		   A.State, 
		   A.Zip,
		   A.Building, 
		   A.Room,
		   null,
		   null, 
		   null,
		   (case 
			when LTRIM(RTRIM(ISNULL(A.Workphone,'')))='' OR LTRIM(RTRIM(ISNULL(A.Workphone,''))) like '%00000%' OR LTRIM(RTRIM(ISNULL(A.Workphone,''))) like '%9999%' then ''
			when LEN(A.Workphone) > 10 then 
				case 
					when A.Workphone not like '%-%' then SUBSTRING(A.Workphone, 1, 3) + '-' + SUBSTRING(A.Workphone, 4, 3) + '-' + SUBSTRING(A.Workphone, 7,4) + ' x' + SUBSTRING(A.Workphone, 11,4)
					else A.Workphone
				end	
			when LEN(A.Workphone) < 10 then
				case 
					when (LTRIM(RTRIM(ISNULL(A.Workphone,''))) like '686%' OR (LTRIM(RTRIM(ISNULL(A.Workphone,''))) like '526%')) then '501-' + SUBSTRING(A.Workphone, 1, 3) + '-' + SUBSTRING(A.Workphone, 4, 4)
					else ''
				end
			else 
				case 
					when A.Workphone not like '%-%' then SUBSTRING(A.Workphone, 1, 3) + '-' + SUBSTRING(A.Workphone, 4, 3) + '-' + SUBSTRING(A.Workphone,7,4)
					else A.Workphone
				end
		   end),
		   (case
			when LTRIM(RTRIM(ISNULL(A.Faxnum,'')))='' OR LTRIM(RTRIM(ISNULL(A.Faxnum,''))) like '%00000%' OR LTRIM(RTRIM(ISNULL(A.Faxnum,''))) like '%9999%' then ''
			when LEN(A.Faxnum) > 10 then 
				case 
					when A.Faxnum not like '%-%' then SUBSTRING(A.Faxnum, 1, 3) + '-' + SUBSTRING(A.Faxnum, 4, 3) + '-' + SUBSTRING(A.Faxnum, 7,4) + ' x' + SUBSTRING(A.Faxnum, 11,4)
					else A.Faxnum
				end	
			when LEN(A.Faxnum) < 10 then
				case 
					when (LTRIM(RTRIM(ISNULL(A.Faxnum,''))) like '686%' OR (LTRIM(RTRIM(ISNULL(A.Faxnum,''))) like '526%')) then '501-' + SUBSTRING(A.Faxnum, 1, 3) + '-' + SUBSTRING(A.Faxnum, 4, 4)
					else ''
				end
			else 
				case 
					when A.Faxnum not like '%-%' then SUBSTRING(A.Faxnum, 1, 3) + '-' + SUBSTRING(A.Faxnum, 4, 3) + '-' + SUBSTRING(A.Faxnum,7,4)
					else A.Faxnum
				end
		   end),
		   LTRIM(RTRIM(ISNULL(A.EmailAddress,''))),
		   '1',
		   '1'
	From (select	(case when X.SAPID is null then Y.ZTXTSAPID else X.SAPID end) SAPID,
			(case when X.LastName is null then Y.ZTXTLNAME else X.LastName end) LastName,
			(case when X.FirstName is null then Y.ZTXTFNAME else X.FirstName end) FirstName,
			(case when X.MiddleName is null then Y.ZTXTMNAME else X.MiddleName end) MiddleName,
			(case when X.Gender is null then Y.ZGENDER else X.Gender end) Gender,
			(case when (X.EmailAddress is null OR LTRIM(RTRIM(X.EmailAddress))='') then Y.ZTXTEMAILADDRESS else X.EmailAddress end) EmailAddress,
			(case when X.Workphone is null then Y.ZTXTPHONE1 else X.Workphone end) Workphone,
			(case when X.Department is null then null else X.Department end) Department,
			(case when X.Slot is null then Y.ZTXTMAILSLOT else X.Slot end) Slot,
			(case when X.Room is null then Y.ZTXTWORKLOCATION else X.Room end) Room,
			(case when X.Building is null then Y.ZTXTBUILDING else X.Building end) Building,
			(case when X.faxnum is null then null else X.faxnum end) faxnum,
			(case when X.title is null then Y.ZTXTPOSDESCRIPT else X.title end) title,
			(case when (X.Room is null or X.Building is null) then (Y.ZTXTWORKLOCATION + (CASE WHEN LTRIM(RTRIM(ISNULL(Y.ZTXTWORKLOCATION,''))) ='' THEN '' ELSE ' ' END) + LTRIM(RTRIM(Y.ZTXTBUILDING))) else (X.Room + (CASE WHEN LTRIM(RTRIM(ISNULL(X.Room,''))) ='' THEN '' ELSE ' ' END) + LTRIM(RTRIM(X.Building))) end) Address1,
			(case when X.Address1 is null then (CASE WHEN LTRIM(RTRIM(Y.ZTXTBUILDING)) like '%University Tower%' THEN '1123 S University Ave.' ELSE '4301 W Markham St.' END) else X.Address1 end) Address2,
			(case when X.City is null then 'Little Rock' else X.City end) City,
			(case when X.State is null then 'AR' else X.State end) State,
			(case when X.Zip is null then (CASE WHEN LTRIM(RTRIM(Y.ZTXTBUILDING)) like '%University Tower%' THEN '72204' ELSE '72205' END) else X.Zip end) Zip
		FROM [HOSP_SQL1].[FacFac].[dbo].[vTRI_SAPFaculty] X
		full outer join [DevDataRepo].[dbo].[ZHRSEC] Y on X.SAPID=Y.ZTXTSAPID) A
	inner join non_tri B 
	ON RIGHT('00000000'+ISNULL(A.SAPID,''),8)=B.SAPID;

	INSERT INTO [Profile.Import].Person
	select cast(CAST(A.SAPID as int) as varchar),
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.FirstName), 
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.MiddleName), 
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.LastName), 
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.FirstName) + ' ' + [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.LastName),
		   null, 
		   A.Address1,
		   A.Address2,
		   'Mail Slot # ' + CASE WHEN LTRIM(RTRIM(A.Slot))='' THEN NULL ELSE LTRIM(RTRIM(A.Slot)) END,
		   null, 
		   (case when (A.Address2 like '%location%' or A.Address2 like '%various%') then null else LTRIM(RTRIM(A.Address2)) + ' ' + LTRIM(RTRIM(A.City)) + ' ' + LTRIM(RTRIM(A.State)) + ' ' +  LTRIM(RTRIM(A.Zip)) end),
		   A.City,
		   A.State, 
		   A.Zip,
		   A.Building, 
		   A.Room,
		   null,
		   null, 
		   null,
		   (case 
			when LTRIM(RTRIM(ISNULL(A.Workphone,'')))='' OR LTRIM(RTRIM(ISNULL(A.Workphone,''))) like '%00000%' OR LTRIM(RTRIM(ISNULL(A.Workphone,''))) like '%9999%' then ''
			when LEN(A.Workphone) > 10 then 
				case 
					when A.Workphone not like '%-%' then SUBSTRING(A.Workphone, 1, 3) + '-' + SUBSTRING(A.Workphone, 4, 3) + '-' + SUBSTRING(A.Workphone, 7,4) + ' x' + SUBSTRING(A.Workphone, 11,4)
					else A.Workphone
				end	
			when LEN(A.Workphone) < 10 then
				case 
					when (LTRIM(RTRIM(ISNULL(A.Workphone,''))) like '686%' OR (LTRIM(RTRIM(ISNULL(A.Workphone,''))) like '526%')) then '501-' + SUBSTRING(A.Workphone, 1, 3) + '-' + SUBSTRING(A.Workphone, 4, 4)
					else ''
				end
			else 
				case 
					when A.Workphone not like '%-%' then SUBSTRING(A.Workphone, 1, 3) + '-' + SUBSTRING(A.Workphone, 4, 3) + '-' + SUBSTRING(A.Workphone,7,4)
					else A.Workphone
				end
		   end),
		   (case
			when LTRIM(RTRIM(ISNULL(A.Faxnum,'')))='' OR LTRIM(RTRIM(ISNULL(A.Faxnum,''))) like '%00000%' OR LTRIM(RTRIM(ISNULL(A.Faxnum,''))) like '%9999%' then ''
			when LEN(A.Faxnum) > 10 then 
				case 
					when A.Faxnum not like '%-%' then SUBSTRING(A.Faxnum, 1, 3) + '-' + SUBSTRING(A.Faxnum, 4, 3) + '-' + SUBSTRING(A.Faxnum, 7,4) + ' x' + SUBSTRING(A.Faxnum, 11,4)
					else A.Faxnum
				end	
			when LEN(A.Faxnum) < 10 then
				case 
					when (LTRIM(RTRIM(ISNULL(A.Faxnum,''))) like '686%' OR (LTRIM(RTRIM(ISNULL(A.Faxnum,''))) like '526%')) then '501-' + SUBSTRING(A.Faxnum, 1, 3) + '-' + SUBSTRING(A.Faxnum, 4, 4)
					else ''
				end
			else 
				case 
					when A.Faxnum not like '%-%' then SUBSTRING(A.Faxnum, 1, 3) + '-' + SUBSTRING(A.Faxnum, 4, 3) + '-' + SUBSTRING(A.Faxnum,7,4)
					else A.Faxnum
				end
		   end),
		   LTRIM(RTRIM(ISNULL(A.EmailAddress,''))),
		   '1',
		   '1'
	From (select	(case when X.SAPID is null then Y.ZTXTSAPID else X.SAPID end) SAPID,
			(case when X.LastName is null then Y.ZTXTLNAME else X.LastName end) LastName,
			(case when X.FirstName is null then Y.ZTXTFNAME else X.FirstName end) FirstName,
			(case when X.MiddleName is null then Y.ZTXTMNAME else X.MiddleName end) MiddleName,
			(case when X.Gender is null then Y.ZGENDER else X.Gender end) Gender,
			(case when (X.EmailAddress is null OR LTRIM(RTRIM(X.EmailAddress))='') then Y.ZTXTEMAILADDRESS else X.EmailAddress end) EmailAddress,
			(case when X.Workphone is null then Y.ZTXTPHONE1 else X.Workphone end) Workphone,
			(case when X.Department is null then null else X.Department end) Department,
			(case when X.Slot is null then Y.ZTXTMAILSLOT else X.Slot end) Slot,
			(case when X.Room is null then Y.ZTXTWORKLOCATION else X.Room end) Room,
			(case when X.Building is null then Y.ZTXTBUILDING else X.Building end) Building,
			(case when X.faxnum is null then null else X.faxnum end) faxnum,
			(case when X.title is null then Y.ZTXTPOSDESCRIPT else X.title end) title,
			(case when (X.Room is null or X.Building is null) then (Y.ZTXTWORKLOCATION + (CASE WHEN LTRIM(RTRIM(ISNULL(Y.ZTXTWORKLOCATION,''))) ='' THEN '' ELSE ' ' END) + LTRIM(RTRIM(Y.ZTXTBUILDING))) else (X.Room + (CASE WHEN LTRIM(RTRIM(ISNULL(X.Room,''))) ='' THEN '' ELSE ' ' END) + LTRIM(RTRIM(X.Building))) end) Address1,
			(case when X.Address1 is null then (CASE WHEN LTRIM(RTRIM(Y.ZTXTBUILDING)) like '%University Tower%' THEN '1123 S University Ave.' ELSE '4301 W Markham St.' END) else X.Address1 end) Address2,
			(case when X.City is null then 'Little Rock' else X.City end) City,
			(case when X.State is null then 'AR' else X.State end) State,
			(case when X.Zip is null then (CASE WHEN LTRIM(RTRIM(Y.ZTXTBUILDING)) like '%University Tower%' THEN '72204' ELSE '72205' END) else X.Zip end) Zip
		FROM [HOSP_SQL1].[FacFac].[dbo].[vTRI_SAPFaculty] X
		full outer join [DevDataRepo].[dbo].[ZHRSEC] Y on X.SAPID=Y.ZTXTSAPID) A
	inner join tri_list B 
	ON RIGHT('00000000'+ISNULL(A.SAPID,''),8)=B.SAPID;
	
	EXECUTE [Profile.Data].[Load_Non_Tri];

	INSERT INTO [Profile.Import].Person
	select cast(CAST(A.SAPID as int) as varchar),
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.FirstName), 
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.MiddleName), 
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.LastName), 
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.FirstName) + ' ' + [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.LastName),
		   null, 
		   A.Address1,
		   A.Address2,
		   'Mail Slot # ' + CASE WHEN LTRIM(RTRIM(A.Slot))='' THEN NULL ELSE LTRIM(RTRIM(A.Slot)) END,
		   null, 
		   (case when (A.Address2 like '%location%' or A.Address2 like '%various%') then null else LTRIM(RTRIM(A.Address2)) + ' ' + LTRIM(RTRIM(A.City)) + ' ' + LTRIM(RTRIM(A.State)) + ' ' +  LTRIM(RTRIM(A.Zip)) end),
		   A.City,
		   A.State, 
		   A.Zip,
		   A.Building, 
		   A.Room,
		   null,
		   null, 
		   null,
		   (case 
			when LTRIM(RTRIM(ISNULL(A.Workphone,'')))='' OR LTRIM(RTRIM(ISNULL(A.Workphone,''))) like '%00000%' OR LTRIM(RTRIM(ISNULL(A.Workphone,''))) like '%9999%' then ''
			when LEN(A.Workphone) > 10 then 
				case 
					when A.Workphone not like '%-%' then SUBSTRING(A.Workphone, 1, 3) + '-' + SUBSTRING(A.Workphone, 4, 3) + '-' + SUBSTRING(A.Workphone, 7,4) + ' x' + SUBSTRING(A.Workphone, 11,4)
					else A.Workphone
				end	
			when LEN(A.Workphone) < 10 then
				case 
					when (LTRIM(RTRIM(ISNULL(A.Workphone,''))) like '686%' OR (LTRIM(RTRIM(ISNULL(A.Workphone,''))) like '526%')) then '501-' + SUBSTRING(A.Workphone, 1, 3) + '-' + SUBSTRING(A.Workphone, 4, 4)
					else ''
				end
			else 
				case 
					when A.Workphone not like '%-%' then SUBSTRING(A.Workphone, 1, 3) + '-' + SUBSTRING(A.Workphone, 4, 3) + '-' + SUBSTRING(A.Workphone,7,4)
					else A.Workphone
				end
		   end),
		   (case
			when LTRIM(RTRIM(ISNULL(A.Faxnum,'')))='' OR LTRIM(RTRIM(ISNULL(A.Faxnum,''))) like '%00000%' OR LTRIM(RTRIM(ISNULL(A.Faxnum,''))) like '%9999%' then ''
			when LEN(A.Faxnum) > 10 then 
				case 
					when A.Faxnum not like '%-%' then SUBSTRING(A.Faxnum, 1, 3) + '-' + SUBSTRING(A.Faxnum, 4, 3) + '-' + SUBSTRING(A.Faxnum, 7,4) + ' x' + SUBSTRING(A.Faxnum, 11,4)
					else A.Faxnum
				end	
			when LEN(A.Faxnum) < 10 then
				case 
					when (LTRIM(RTRIM(ISNULL(A.Faxnum,''))) like '686%' OR (LTRIM(RTRIM(ISNULL(A.Faxnum,''))) like '526%')) then '501-' + SUBSTRING(A.Faxnum, 1, 3) + '-' + SUBSTRING(A.Faxnum, 4, 4)
					else ''
				end
			else 
				case 
					when A.Faxnum not like '%-%' then SUBSTRING(A.Faxnum, 1, 3) + '-' + SUBSTRING(A.Faxnum, 4, 3) + '-' + SUBSTRING(A.Faxnum,7,4)
					else A.Faxnum
				end
		   end),
		   LTRIM(RTRIM(ISNULL(A.EmailAddress,''))),
		   '1',
		   '1'
	From (select	(case when X.SAPID is null then Y.ZTXTSAPID else X.SAPID end) SAPID,
			(case when X.LastName is null then Y.ZTXTLNAME else X.LastName end) LastName,
			(case when X.FirstName is null then Y.ZTXTFNAME else X.FirstName end) FirstName,
			(case when X.MiddleName is null then Y.ZTXTMNAME else X.MiddleName end) MiddleName,
			(case when X.Gender is null then Y.ZGENDER else X.Gender end) Gender,
			(case when (X.EmailAddress is null OR LTRIM(RTRIM(X.EmailAddress))='') then Y.ZTXTEMAILADDRESS else X.EmailAddress end) EmailAddress,
			(case when X.Workphone is null then Y.ZTXTPHONE1 else X.Workphone end) Workphone,
			(case when X.Department is null then null else X.Department end) Department,
			(case when X.Slot is null then Y.ZTXTMAILSLOT else X.Slot end) Slot,
			(case when X.Room is null then Y.ZTXTWORKLOCATION else X.Room end) Room,
			(case when X.Building is null then Y.ZTXTBUILDING else X.Building end) Building,
			(case when X.faxnum is null then null else X.faxnum end) faxnum,
			(case when X.title is null then Y.ZTXTPOSDESCRIPT else X.title end) title,
			(case when (X.Room is null or X.Building is null) then (Y.ZTXTWORKLOCATION + (CASE WHEN LTRIM(RTRIM(ISNULL(Y.ZTXTWORKLOCATION,''))) ='' THEN '' ELSE ' ' END) + LTRIM(RTRIM(Y.ZTXTBUILDING))) else (X.Room + (CASE WHEN LTRIM(RTRIM(ISNULL(X.Room,''))) ='' THEN '' ELSE ' ' END) + LTRIM(RTRIM(X.Building))) end) Address1,
			(case when X.Address1 is null then (CASE WHEN LTRIM(RTRIM(Y.ZTXTBUILDING)) like '%University Tower%' THEN '1123 S University Ave.' ELSE '4301 W Markham St.' END) else X.Address1 end) Address2,
			(case when X.City is null then 'Little Rock' else X.City end) City,
			(case when X.State is null then 'AR' else X.State end) State,
			(case when X.Zip is null then (CASE WHEN LTRIM(RTRIM(Y.ZTXTBUILDING)) like '%University Tower%' THEN '72204' ELSE '72205' END) else X.Zip end) Zip
		FROM [HOSP_SQL1].[FacFac].[dbo].[vTRI_SAPFaculty] X
		full outer join [DevDataRepo].[dbo].[ZHRSEC] Y on X.SAPID=Y.ZTXTSAPID) A
	inner join non_tri_list B 
	ON RIGHT('00000000'+ISNULL(A.SAPID,''),8)=B.ZTXTSAPID;


	with a as (
	select ROW_NUMBER() over (partition by internalusername order by internalusername) as rn, * 
	from [Profile.Import].Person) delete from a where rn > 1;

	INSERT INTO [Profile.Import].[User]
	SELECT	cast(cast(A.SAPID as int) as varchar), 
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.FirstName), 
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.LastName), 
		   [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.FirstName) + ' ' + [ProfilesStaging].[dbo].[CapitalizeFirstLetter](A.LastName),
		'',
		CASE	WHEN ISNULL(A.Department,'')='' THEN (CASE	
			WHEN C.STEXT like 'COM %' THEN REPLACE(C.STEXT,'COM ','') + ', College of Medicine'
			WHEN C.STEXT like 'COPH %' THEN REPLACE(C.STEXT,'COPH ','') + ', College of Public Health' 
			WHEN C.STEXT like 'CPH %' THEN REPLACE(C.STEXT,'CPH ','') + ', College of Public Health' 
			WHEN C.STEXT like 'CHP %' THEN REPLACE(C.STEXT,'CHP ','') + ', College of Health Professions'
			WHEN C.STEXT like 'COP %' THEN REPLACE(C.STEXT,'COP ','') + ', College of Pharmacy'
			WHEN C.STEXT like 'CON %' THEN REPLACE(C.STEXT,'CON ','') + ', College of Nursing'
			ELSE C.STEXT END) ELSE  (CASE	
							WHEN A.Department like 'COM%' THEN REPLACE(A.Department,'COM','') + 'College of Medicine'
							WHEN A.Department like 'COPH%' THEN REPLACE(A.Department,'COPH','') + 'College of Public Health' 
							WHEN A.Department like 'CPH%' THEN REPLACE(A.Department,'CPH','') + 'College of Public Health' 
							WHEN A.Department like 'CHP%' THEN REPLACE(A.Department,'CHP','') + 'College of Health Professions'
							WHEN A.Department like 'COP%' THEN REPLACE(A.Department,'COP','') + 'College of Pharmacy'
							WHEN A.Department like 'CON%' THEN REPLACE(A.Department,'CON','') + 'College of Nursing'
							ELSE A.Department END) END, --A.Department
		LTRIM(RTRIM(ISNULL(A.EmailAddress,''))), 
		'1'
	From (select	(case when X.SAPID is null then Y.ZTXTSAPID else X.SAPID end) SAPID,
			(case when X.LastName is null then Y.ZTXTLNAME else X.LastName end) LastName,
			(case when X.FirstName is null then Y.ZTXTFNAME else X.FirstName end) FirstName,
			(case when X.MiddleName is null then Y.ZTXTMNAME else X.MiddleName end) MiddleName,
			(case when X.Gender is null then Y.ZGENDER else X.Gender end) Gender,
			(case when (X.EmailAddress is null OR LTRIM(RTRIM(X.EmailAddress))='') then Y.ZTXTEMAILADDRESS else X.EmailAddress end) EmailAddress,
			(case when X.Workphone is null then Y.ZTXTPHONE1 else X.Workphone end) Workphone,
			(case when X.Department is null then null else X.Department end) Department,
			(case when X.Slot is null then Y.ZTXTMAILSLOT else X.Slot end) Slot,
			(case when X.Room is null then Y.ZTXTWORKLOCATION else X.Room end) Room,
			(case when X.Building is null then Y.ZTXTBUILDING else X.Building end) Building,
			(case when X.faxnum is null then null else X.faxnum end) faxnum,
			(case when X.title is null then Y.ZTXTPOSDESCRIPT else X.title end) title,
			(case when (X.Room is null or X.Building is null) then (Y.ZTXTWORKLOCATION + (CASE WHEN LTRIM(RTRIM(ISNULL(Y.ZTXTWORKLOCATION,''))) ='' THEN '' ELSE ' ' END) + LTRIM(RTRIM(Y.ZTXTBUILDING))) else (X.Room + (CASE WHEN LTRIM(RTRIM(ISNULL(X.Room,''))) ='' THEN '' ELSE ' ' END) + LTRIM(RTRIM(X.Building))) end) Address1,
			(case when X.Address1 is null then (CASE WHEN LTRIM(RTRIM(Y.ZTXTBUILDING)) like '%University Tower%' THEN '1123 S University Ave.' ELSE '4301 W Markham St.' END) else X.Address1 end) Address2,
			(case when X.City is null then 'Little Rock' else X.City end) City,
			(case when X.State is null then 'AR' else X.State end) State,
			(case when X.Zip is null then (CASE WHEN LTRIM(RTRIM(Y.ZTXTBUILDING)) like '%University Tower%' THEN '72204' ELSE '72205' END) else X.Zip end) Zip,
			Y.ZTXTDEPTNUMBER Department_Number, 
			Y.ZTXTSUBDEPTNUM Sub_Department_Number
		FROM [HOSP_SQL1].[FacFac].[dbo].[vTRI_SAPFaculty] X
		full outer join [DevDataRepo].[dbo].[ZHRSEC] Y on X.SAPID=Y.ZTXTSAPID) A
	left outer join [HOSP_SQL1].[FacFac].[dbo].[vTRI_Appointments] B ON RIGHT('00000000'+ISNULL(A.SAPID,''),8)=B.SAPID
	left outer join [DevDataRepo].[dbo].ZHRITDEPTXT C ON A.Department_Number=C.OBJID
	left outer join [DevDataRepo].[dbo].ZHRITDEPTXT D ON A.Sub_Department_Number=D.OBJID	
	where RIGHT('00000000'+ISNULL(A.SAPID,''),8) is not null and B.SAPID is null
	AND ISNUMERIC(A.SAPID)=1;

	delete A
	from [Profile.Import].[User] A 
	inner join [Profile.Import].Person B on A.internalusername=B.internalusername;

	INSERT INTO [Profile.Import].PersonAffiliation
	select * From [ProfilesStaging].[Profile.Import].[PersonAffiliation_T32];
	
	INSERT INTO [ProfilesStaging].[Profile.Import].PersonAffiliation
	select	internalusername,
		title,
		emailaddr,
		primaryaffiliation,
		affiliationorder,
		institutionname,
		institutionabbreviation,
		departmentname,
		departmentvisible,
		divisionname,
		facultyrank,
		facultyrankorder 
	From	[ProfilesStaging].[dbo].[non_tri_list_affiliations];

	INSERT INTO [Profile.Import].PersonAffiliation
	SELECT cast(CAST(A.SAPID as int) as varchar), 
		   B.PositionName,
		   null,
		   (CASE WHEN B.IsPrimaryAppointment='1' THEN '1' ELSE '0' END), 
		   '1', 
		   'University of Arkansas for Medical Sciences',
		   'UAMS', 
		   case 
			when ltrim(rtrim(isnull(B.departmentname,'')))='' then 'College of ' + ltrim(rtrim(B.CollegeName))
			else  ltrim(rtrim(B.departmentname)) + ', College of ' + ltrim(rtrim(B.CollegeName))
		   end, -- DepartmentName 
		   (CASE WHEN ltrim(rtrim(isnull(B.departmentname,'')))='' THEN '0' ELSE '1' END), 
		   ltrim(rtrim(isnull(B.DivisionName,''))),
		   null, 
		   null
	From (select	(case when X.SAPID is null then Y.ZTXTSAPID else X.SAPID end) SAPID,
			(case when X.LastName is null then Y.ZTXTLNAME else X.LastName end) LastName,
			(case when X.FirstName is null then Y.ZTXTFNAME else X.FirstName end) FirstName,
			(case when X.MiddleName is null then Y.ZTXTMNAME else X.MiddleName end) MiddleName,
			(case when X.Gender is null then Y.ZGENDER else X.Gender end) Gender,
			(case when (X.EmailAddress is null OR LTRIM(RTRIM(X.EmailAddress))='') then Y.ZTXTEMAILADDRESS else X.EmailAddress end) EmailAddress,
			(case when X.Workphone is null then Y.ZTXTPHONE1 else X.Workphone end) Workphone,
			(case when X.Department is null then null else X.Department end) Department,
			(case when X.Slot is null then Y.ZTXTMAILSLOT else X.Slot end) Slot,
			(case when X.Room is null then Y.ZTXTWORKLOCATION else X.Room end) Room,
			(case when X.Building is null then Y.ZTXTBUILDING else X.Building end) Building,
			(case when X.faxnum is null then null else X.faxnum end) faxnum,
			(case when X.title is null then Y.ZTXTPOSDESCRIPT else X.title end) title,
			(case when (X.Room is null or X.Building is null) then (Y.ZTXTWORKLOCATION + (CASE WHEN LTRIM(RTRIM(ISNULL(Y.ZTXTWORKLOCATION,''))) ='' THEN '' ELSE ' ' END) + LTRIM(RTRIM(Y.ZTXTBUILDING))) else (X.Room + (CASE WHEN LTRIM(RTRIM(ISNULL(X.Room,''))) ='' THEN '' ELSE ' ' END) + LTRIM(RTRIM(X.Building))) end) Address1,
			(case when X.Address1 is null then (CASE WHEN LTRIM(RTRIM(Y.ZTXTBUILDING)) like '%University Tower%' THEN '1123 S University Ave.' ELSE '4301 W Markham St.' END) else X.Address1 end) Address2,
			(case when X.City is null then 'Little Rock' else X.City end) City,
			(case when X.State is null then 'AR' else X.State end) State,
			(case when X.Zip is null then (CASE WHEN LTRIM(RTRIM(Y.ZTXTBUILDING)) like '%University Tower%' THEN '72204' ELSE '72205' END) else X.Zip end) Zip,
			Y.ZTXTDEPTNUMBER Department_Number, 
			Y.ZTXTSUBDEPTNUM Sub_Department_Number
		FROM [HOSP_SQL1].[FacFac].[dbo].[vTRI_SAPFaculty] X
		full outer join [DevDataRepo].[dbo].[ZHRSEC] Y on X.SAPID=Y.ZTXTSAPID) A
	inner join [HOSP_SQL1].[FacFac].[dbo].[vTRI_Appointments] B ON RIGHT('00000000'+ISNULL(A.SAPID,''),8)=B.SAPID
	where not 
	exists	(select	* 
			from	[ProfilesStaging].[dbo].[non_tri_list_affiliations] Z
			where B.SAPID = RIGHT('00000000'+ISNULL(Z.internalusername,''),8));
			
	with a as (
	select ROW_NUMBER() over (partition by internalusername,
										   title, 
										   emailaddr, 
										   primaryaffiliation, 
										   institutionname,
										   institutionabbreviation, 
										   departmentname, 
										   departmentvisible, 
										   divisionname, 
										   facultyrank, 
										   facultyrankorder
							  order by internalusername) as rn, * 
	from [Profile.Import].[PersonAffiliation]) delete from a where rn > 1;

	with a as (
	select ROW_NUMBER() over (PARTITION by internalusername order by primaryaffiliation desc) as rn, * 
	from [Profile.Import].PersonAffiliation) update a set affiliationorder = rn;

	update [Profile.Import].[PersonAffiliation] set departmentname='' where departmentname is null;
	update [Profile.Import].[PersonAffiliation] set divisionname='' where divisionname is null;

	update A 
	set A.primaryaffiliation='1', A.emailaddr='X'
	From  [Profile.Import].[PersonAffiliation] A 
	inner join (SELECT internalusername FROM [Profile.Import].[PersonAffiliation] GROUP BY internalusername HAVING SUM(primaryaffiliation*1)=0) B
	on A.internalusername=B.internalusername;

	update [Profile.Import].[PersonAffiliation] set emailaddr=null where emailaddr='X';

	update [Profile.Import].[PersonAffiliation] set primaryaffiliation='0' where affiliationorder <> '1';

	update A
	set A.FacultyRank=B.FacultyRank, A.facultyrankorder=B.facultyranksort
	from [Profile.Import].[PersonAffiliation] A 
	inner join [Profile.Import].[Person.FacultyRank] B on A.title=B.FacultyRank;
	
	--update [Profile.Import].[PersonAffiliation] set FacultyRank='Other', facultyrankorder='28' 
	--where FacultyRank is null and facultyrankorder is null;

	update [ProfilesStaging].[Profile.Import].[USER] set canbeproxy=0;

	update A
	set A.canbeproxy=1 
	from [ProfilesStaging].[Profile.Import].[USER] A
	inner join [DevDataRepo].[dbo].[ZHRSEC] B on RIGHT('00000000'+ISNULL(A.internalusername,''),8)=B.ZTXTSAPID
	inner join [DevDataRepo].[dbo].[ZHRITDEPTXT] C on B.ZTXTDEPTNUMBER=C.OBJID
	inner join [DevDataRepo].[dbo].[ZHRITDEPTXT] D on B.ZTXTSUBDEPTNUM=D.OBJID
	where (C.STEXT like '%biomed%informa%' or D.STEXT like '%biomed%informa%') or A.internalusername='39106'

	--update [Profile.Import].[Person] set internalusername=900000 where internalusername='tester';
	--update [Profile.Import].[user] set internalusername=900000 where internalusername='tester';	
	
	-- updating for those profiles that are no longer in FacFacts but were previosuly
	update [ProfilesStaging].[Profile.Import].[PersonAffiliation]
	set departmentname=ltrim(rtrim(departmentname)) + ', College of Medicine'
	where departmentname in 
	('Anesthesiology', 'Biochemistry & Molecular Biology', 'Dermatology', 'Emergency Medicine', 'Family And Preventive Medicine', 'Geriatrics', 'Internal Medicine', 'Medical Humanities', 'Microbiology And Immunology', 'Neurobiology & Developmental Science', 'Neurology', 'Obstetrics And Gynecology', 'Ophthalmology', 'Orthopaedics', 'Otolaryngology', 'Pathology', 'Pediatrics', 'Pharmacology and Toxicology', 'Physical Medicine and Rehabilitation', 'Psychiatry', 'Radiology', 'Urology')
	
	
END;







GO

