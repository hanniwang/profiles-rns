USE [ProfilesStaging]
GO

/****** Object:  StoredProcedure [Profile.Import].[SCHOLAR_KL2]    Script Date: 05/01/2014 10:55:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Profile.Import].[SCHOLAR_KL2]
AS
BEGIN
		insert into [ProfilesStaging].[Profile.Import].[Person_T32] (internalusername,firstname,middlename,lastname,displayname,suffix,addressline1,addressline2,addressline3,addressline4,addressstring,City,State,Zip,building,room,floor,latitude,longitude,phone,fax,emailaddr,isactive,isvisible)
		select cast(CAST(A.SAPID as int) as varchar),
			   A.FirstName, 
			   A.MiddleName, 
			   A.LastName, 
			   A.FirstName + ' ' + A.LastName, 
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
		inner join  [ProfilesStaging].[dbo].[KL2_Scholar] B on A.SAPID=B.sapid 
		left outer join [HOSP_SQL1].[FacFac].[dbo].[vTRI_Appointments] C on B.SAPID=C.SAPID
		where B.SAPID is not null 
		and C.SAPID is null and B.isprimary='1';
		
		insert into [ProfilesStaging].[Profile.Import].[PersonAffiliation_T32] (internalusername,title,emailaddr,primaryaffiliation,affiliationorder,institutionname,institutionabbreviation,departmentname,departmentvisible,divisionname,facultyrank,facultyrankorder)
		select cast(CAST(A.SAPID as int) as varchar),
			   A.Title, 
			   null, 
			   '1', 
			   '1',
			   'University of Arkansas for Medical Sciences',
			   'UAMS',
				CASE	WHEN ISNULL(A.Department,'')='' THEN (CASE	
						WHEN D.STEXT like 'COM %' THEN B.department + ', College of Medicine'
						WHEN D.STEXT like 'COPH %' THEN B.department + ', College of Public Health' 
						WHEN D.STEXT like 'CPH %' THEN B.department + ', College of Public Health' 
						WHEN D.STEXT like 'CHP %' THEN B.department + ', College of Health Professions'
						WHEN D.STEXT like 'COP %' THEN B.department + ', College of Pharmacy'
						WHEN D.STEXT like 'CON %' THEN B.department + ', College of Nursing'
				END) ELSE  (CASE	
								WHEN A.Department like 'COM%' THEN REPLACE(A.Department,'COM','') + 'College of Medicine'
								WHEN A.Department like 'COPH%' THEN REPLACE(A.Department,'COPH','') + 'College of Public Health' 
								WHEN A.Department like 'CPH%' THEN REPLACE(A.Department,'CPH','') + 'College of Public Health' 
								WHEN A.Department like 'CHP%' THEN REPLACE(A.Department,'CHP','') + 'College of Health Professions'
								WHEN A.Department like 'COP%' THEN REPLACE(A.Department,'COP','') + 'College of Pharmacy'
								WHEN A.Department like 'CON%' THEN REPLACE(A.Department,'CON','') + 'College of Nursing'
							ELSE A.Department END) END, --A.Department, 
			   (CASE WHEN ISNULL(B.department,'')='' THEN 0 ELSE 1 END), 
			   ISNULL(CASE	
							WHEN E.STEXT like 'COM %' THEN REPLACE(E.STEXT,'COM ','')
							WHEN E.STEXT like 'COPH %' THEN REPLACE(E.STEXT,'COPH ','')
							WHEN E.STEXT like 'CPH %' THEN REPLACE(E.STEXT,'CPH ','')
							WHEN E.STEXT like 'CHP %' THEN REPLACE(E.STEXT,'CHP ','')
							WHEN E.STEXT like 'COP %' THEN REPLACE(E.STEXT,'COP ','')
							WHEN E.STEXT like 'CON %' THEN REPLACE(E.STEXT,'CON ','')
							ELSE E.STEXT END,''), 
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
		inner join [ProfilesStaging].[dbo].[KL2_Scholar] B on A.SAPID=B.sapid
		left outer join [HOSP_SQL1].[FacFac].[dbo].[vTRI_Appointments] C on B.SAPID=C.SAPID
		inner join [DevDataRepo].[dbo].ZHRITDEPTXT D ON A.Department_Number=D.OBJID
		inner join [DevDataRepo].[dbo].ZHRITDEPTXT E ON A.Sub_Department_Number=E.OBJID
		where B.SAPID is not null 
		and C.SAPID is null and B.isprimary='1';
END;





GO

