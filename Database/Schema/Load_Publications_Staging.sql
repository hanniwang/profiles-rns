USE [ProfilesRNS]
GO

/****** Object:  StoredProcedure [dbo].[Load_Publications_Staging]    Script Date: 05/14/2014 15:12:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Load_Publications_Staging] as
BEGIN

		truncate table [ProfilesStaging].[dbo].[Load_Publications];
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
				PRF_PERSON.PersonID, 
				null, 
				[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
				null, 
				FF_PUB.txt3, --fix this - Publication Title
				case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
				end, 
				null, 
				null, 
				null, 
				null,
				(case 
						when len(txt4) < 76 then txt4
						else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt4,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
				end),  -- Place of Publication
				null, 
				null, 
				null, 
				txt7, -- pageinfo
				CAST(BibliographyID as varchar) + 
				CASE WHEN txt8='' or txt8 is null then '' else ' - Total No. of Citations - ' + CAST(txt8 as varchar) end, 
				FF_PUB.txt5, --fix this - Publisher, 
				null, 
				null, --fix this for ConfNm
				null, 
				null, 
				null, 
				null,
				null, 
				null, 
				case 
				when ISDATE(txt6)=1 THEN cast(CAST(txt6 as DATE) as varchar(10))
				when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
			end, --fix this for PublicationDT
				'', --Abstract, 
				[ProfilesRNS].[dbo].[Publications_Author](BibliographyID) , 
				null, --fix this for URL
				RecordDate, 
				PRF_PERSON.PersonID, 
				RecordDate, 
				PRF_PERSON.PersonID 
		--select * 
		From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
		inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
		where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
		and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
		and FF_PUB.Expr5 in ('Biography');
		------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
				PRF_PERSON.PersonID, 
				null, 
				[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
				null, 
				FF_PUB.txt4, --fix this - PubTitle
				case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
				end, 
				null, 
				null, 
				null, 
				null,
				(case 
					when len(txt3) < 76 then txt3
					else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt3,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
				end),  -- Place of Publication
				null, 
				null, 
				null, 
				txt6, -- Pagination
				CAST(BibliographyID as varchar) + 
				CASE WHEN txt7='' or txt7 is null then '' else ' - Chapter #: ' + CAST(txt7 as varchar) end + 
				CASE WHEN txt8='' or txt8 is null then '' else ' - Chapter Title: ' + CAST(txt7 as varchar) end,
				FF_PUB.txt4, --fix this - Publisher, 
				null, 
				null, --fix this for ConfNm
				null, 
				null, 
				null, 
				null,
				null, 
				null, 
				case 
				when ISDATE(txt5)=1 THEN cast(CAST(txt5 as DATE) as varchar(10))
				when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
			end, --fix this for PublicationDT
				'', --Abstract, 
				[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
				null, --fix this for URL
				RecordDate, 
				PRF_PERSON.PersonID, 
				RecordDate, 
				PRF_PERSON.PersonID 
		--select * 
		From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
		inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
		where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
		and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
		and FF_PUB.Expr5 in ('Book');
		------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
				PRF_PERSON.PersonID, 
				null, 
				[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
				null, 
				FF_PUB.txt3, --fix this - PubTitle
				case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
				end, 
				null, 
				null, 
				null, 
				null,
				null, --Place of Pub,  
				(case when txt6 like 'http%' or len(txt6) > 30 then '' else txt6 end), -- Volume #, 
				null, -- Part of Volume #, 
				(case when txt7 like 'http%'  or len(txt7) > 30 then '' else txt7 end), -- Issue #, 
				(case when txt8 like 'http%'  or len(txt8) > 30 then '' else txt8 end), -- Pagination,
				CAST(BibliographyID as varchar) + 
				CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end, 
				FF_PUB.txt3, --fix this - Publisher, 
				null, 
				null, --fix this for ConfNm
				null, 
				null, 
				null, 
				null,
				null, 
				null, 
				case 
				when (	case 
						when ISDATE(case when txt5='' OR txt5 is null OR txt5 like '%-%' then '' else txt5 end + ' ' + txt4)=1 THEN cast(CAST(case when txt5='' OR txt5 is null  OR txt5 like '%-%' then '' else txt5 end + ' ' + txt4 as DATE) as varchar(10))
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end) > '1900-01-01' 
				and (	case
						when ISDATE(case when txt5='' OR txt5 is null OR txt5 like '%-%' then '' else txt5 end + ' ' + txt4)=1 THEN cast(CAST(case when txt5='' OR txt5 is null  OR txt5 like '%-%' then '' else txt5 end + ' ' + txt4 as DATE) as varchar(10))
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end) < '2050-01-01' then 
					case 
						when ISDATE(case when txt5='' OR txt5 is null OR txt5 like '%-%' then '' else txt5 end + ' ' + txt4)=1 THEN cast(CAST(case when txt5='' OR txt5 is null  OR txt5 like '%-%' then '' else txt5 end + ' ' + txt4 as DATE) as varchar(10))
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end
			end, --fix this for PublicationDT
				'', --Abstract, 
				[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
				(case 
        			when txt6 like 'http%' or txt6 like 'www%' then txt6 
        			else case 
        				when txt7 like 'http%' or txt7 like 'www%'  then txt7
        				else case 
        					when txt8 like 'http%'  or txt8 like 'www%' then txt8
        					else null
        					 end
        				 end
				end), --fix this for URL
				RecordDate, 
			PRF_PERSON.PersonID, 
				RecordDate, 
				PRF_PERSON.PersonID 
		--select * 
		From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
		inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
		where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
		and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
		and FF_PUB.Expr5 in ('Journal Article');
		----------------------------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
				PRF_PERSON.PersonID, 
				null, 
				[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
				null, 
				FF_PUB.txt3, --fix this - PubTitle
				case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
				end, 
				null, 
				null, 
				null, 
				null,
				null, --Place of Pub,  
				(case when txt6 like 'http%' or len(txt6) > 30 then '' else txt6 end), -- Volume #, 
				null, -- Part of Volume #, 
				(case when txt7 like 'http%'  or len(txt7) > 30 then '' else txt7 end), -- Issue #, 
				(case when txt8 like 'http%'  or len(txt8) > 30 then '' else txt8 end), -- Pagination,
				CAST(BibliographyID as varchar) + 
				CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end, 
				FF_PUB.txt3, --fix this - Publisher, 
				null, 
				null, --fix this for ConfNm
				null, 
				null, 
				null, 
				null,
				null, 
				null, 
				case 
				when (	case 
						when ISDATE(case when txt5='' OR txt5 is null OR txt5 like '%-%' then '' else txt5 end + ' ' + txt4)=1 THEN cast(CAST(case when txt5='' OR txt5 is null  OR txt5 like '%-%' then '' else txt5 end + ' ' + txt4 as DATE) as varchar(10))
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end) > '1900-01-01' 
				and (	case
						when ISDATE(case when txt5='' OR txt5 is null OR txt5 like '%-%' then '' else txt5 end + ' ' + txt4)=1 THEN cast(CAST(case when txt5='' OR txt5 is null  OR txt5 like '%-%' then '' else txt5 end + ' ' + txt4 as DATE) as varchar(10))
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end) < '2050-01-01' then 
					case 
						when ISDATE(case when txt5='' OR txt5 is null OR txt5 like '%-%' then '' else txt5 end + ' ' + txt4)=1 THEN cast(CAST(case when txt5='' OR txt5 is null  OR txt5 like '%-%' then '' else txt5 end + ' ' + txt4 as DATE) as varchar(10))
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end
			end, --fix this for PublicationDT
				'', --Abstract, 
				[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
				(case 
        			when txt6 like 'http%' or txt6 like 'www%' then txt6 
        			else case 
        				when txt7 like 'http%' or txt7 like 'www%'  then txt7
        				else case 
        					when txt8 like 'http%'  or txt8 like 'www%' then txt8
        					else null
        					 end
        				 end
				end), --fix this for URL
				RecordDate, 
			PRF_PERSON.PersonID, 
				RecordDate, 
				PRF_PERSON.PersonID 
		--select * 
		From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
		inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
		where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
		and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
		and FF_PUB.Expr5 in ('Research Article');
		------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
				PRF_PERSON.PersonID, 
				null, 
				[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
				null, 
				FF_PUB.txt3, --fix this - PubTitle
				case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
				end, 
				null, 
				null, 
				null, 
				null,
				(case 
					when len(txt4) < 76 then txt4
					else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt4,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
				end),  -- Place of Publication
				null, 
				null, 
				null, 
				null, 
				CAST(BibliographyID as varchar) + 
				CASE WHEN txt7='' or txt7 is null then '' else ' - Number of Message: ' + CAST(txt7 as varchar) end + 
				CASE WHEN txt9='' or txt9 is null then '' else ' - Availability : ' + CAST(txt9 as varchar) end,
				FF_PUB.txt3, --fix this - Publisher, 
				null, 
				null, --fix this for ConfNm
				null, 
				null, 
				null, 
				null,
				null, 
				null, 
			case 
				when ISDATE(txt6)=1 THEN cast(CAST(txt6 as DATE) as varchar(10))
				when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
			end, --fix this for PublicationDT
				'', --Abstract, 
				[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
				(case 
        			when txt4 like 'http%' or (txt4 like 'www%' and len(txt4)>3) then txt4
        			else case 
        				when txt9 like 'http%'  or txt9 like 'www%' then txt9
        				 end
				end), --fix this for URL
				RecordDate, 
			PRF_PERSON.PersonID, 
				RecordDate, 
				PRF_PERSON.PersonID 
		--select * 
		From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
		inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
		where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
		and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
		and FF_PUB.Expr5 in ('Discussion List (E-media)');

		------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
				PRF_PERSON.PersonID, 
				null, 
				[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
				null, 
				FF_PUB.txt3, --fix this - PubTitle
				case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
				end, 
				null, 
				null, 
				null, 
				null,
				(case 
					when len(txt4) < 76 then txt4
					else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt4,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
				end),  -- Place of Publication 
				null, 
				null, 
				null, 
				(case when txt7 like 'http%'  or len(txt7) > 30 then '' else txt7 end), --Pagination, 
				CAST(BibliographyID as varchar) + 
				CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end, 
				FF_PUB.txt5, --fix this - Publisher, 
				null, 
				null, --fix this for ConfNm
				null, 
				null, 
				null, 
				FF_PUB.txt3, --DissUnivName
				null, 
				null, 
				case 
				when ISDATE(txt6)=1 THEN cast(CAST(txt6 as DATE) as varchar(10))
				when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
			end, --fix this for PublicationDT
				'', --Abstract, 
				[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
				null, --fix this for URL
				RecordDate, 
				PRF_PERSON.PersonID, 
				RecordDate, 
				PRF_PERSON.PersonID 
		--select * 
		From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
		inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
		where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
		and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
		and FF_PUB.Expr5 in ('Dissertation');
		------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
				PRF_PERSON.PersonID, 
				null, 
				[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
				null, 
				null, --fix this - PubTitle
				case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
				end, 
				null, 
				null, 
				null, 
				null,
				null,  -- Place of Publication
				(case when txt6 like 'http%' or len(txt6) > 30 then '' else txt6 end), -- Volume # -- Availability  
				null, -- Part of Volume #, 
				(case when txt7 like 'http%'  or len(txt7) > 30 then '' else txt7 end), -- Issue # -- Language
				(case when txt8 like 'http%'  or len(txt8) > 30 then '' else txt8 end), -- Pagination -- Notes      
				CAST(BibliographyID as varchar) + 
				CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end,
				FF_PUB.txt3, --fix this - Publisher, 
				null, 
				null, --fix this for ConfNm
				null, 
				null, 
				null, 
				null,
				null, 
				null, 
				case 
				when ISDATE(txt4)=1 THEN cast(CAST(txt4 as DATE) as varchar(10))
				when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
			end, --fix this for PublicationDT
				'', --Abstract, 
				[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
				(case 
        			when txt6 like 'http%' or (txt6 like 'www%' and len(txt6)>3) then txt6
        			else case 
        				when txt3 like 'http%'  or txt3 like 'www%' then txt3
        				 end
				end), --fix this for URL
				RecordDate, 
				PRF_PERSON.PersonID, 
				RecordDate, 
				PRF_PERSON.PersonID 
		--select * 
		From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
		inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
		where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
		and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
		and FF_PUB.Expr5 in ('Electronic Mail (E-media)');
		------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
				PRF_PERSON.PersonID, 
				null, 
				[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
				null, 
				txt4, --fix this - PubTitle
				case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
				end, 
				null, 
				null, 
				null, 
				case when len(txt3) > 30 then '' else txt3 end, --Edition
				(case 
					when len(txt5) < 76 then txt5
					else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt5,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
				end),  -- Place of Publication  
				(case when txt9 like 'http%' or len(txt9) > 30 then '' else txt9 end), -- Volume # -- Availability  
				null, -- Part of Volume #, 
				(case when txt10 like 'http%'  or len(txt10) > 30 then '' else txt10 end), -- Issue # -- Language
				(case when txt11 like 'http%'  or len(txt11) > 30 then '' else txt11 end), -- Pagination -- Notes     
				CAST(BibliographyID as varchar) + 
				CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end,
				FF_PUB.txt6, --fix this - Publisher, 
				null, 
				null, --fix this for ConfNm
				null, 
				null, 
				null, 
				null,
				null, 
				null, 
				case 
				when ISDATE(txt7)=1 THEN cast(CAST(txt7 as DATE) as varchar(10))
				when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
			end, --fix this for PublicationDT
			'', --Abstract, 
				[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
				null, --fix this for URL
				RecordDate, 
				PRF_PERSON.PersonID, 
				RecordDate, 
				PRF_PERSON.PersonID 
		--select * 
		From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
		inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
		where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
		and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
		and FF_PUB.Expr5 in ('Magazine');
		------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
				PRF_PERSON.PersonID, 
				null, 
				[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
				null, 
				null, --fix this - PubTitle
				case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
				end, 
				null, 
				null, 
				null, 
				null,
				null,  --Place of Publication
				null, -- Volume #
				(case when txt8 like 'http%'  or len(txt8) > 15 then '' else txt8 end), -- Part of Volume #, 
				null, -- Issue #
				(case when txt6 like 'http%'  or len(txt6) > 30 then '' else txt6 end), -- Pagination -- Page     
				CAST(BibliographyID as varchar) + 
				CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end, 
				FF_PUB.txt3, --fix this - Publisher, 
				null, 
				null, --fix this for ConfNm
				null, 
				null, 
				null, 
				null,
				(case when txt7 like 'http%'  or len(txt7) > 15 then '' else txt7 end),  -- Column
				(case when txt5 like 'http%' or len(txt5) > 15 then '' else txt5 end), -- Section
				case 
				when ISDATE(txt4)=1 THEN cast(CAST(txt4 as DATE) as varchar(10))
				when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
			end, --fix this for PublicationDT
				'', --Abstract, 
				[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
				null, --fix this for URL
				RecordDate, 
			PRF_PERSON.PersonID, 
				RecordDate, 
				PRF_PERSON.PersonID 
		--select * 
		From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
		inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
		where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
		and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
		and FF_PUB.Expr5 in ('Newspaper Article');
		------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
				PRF_PERSON.PersonID, 
				null, 
				[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
				null, 
				FF_PUB.txt3, --fix this - PubTitle
				case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
				end, 
				null, 
				null, 
				null, 
				null,
				(case 
					when len(txt4) < 76 then txt4
					else REPLACE(REPLACE(txt4,'Department of','Dept of'),' ,',',')
				end),  
				null, 
				null, 
				(case when txt7 like 'http%'  or len(txt7) > 30 then '' else txt7 end), 
				(case when txt8 like 'http%'  or len(txt8) > 30 then '' else txt8 end), -- Pagination -- Page     
				CAST(BibliographyID as varchar) + 
				CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end, 
				FF_PUB.txt5, --fix this - Publisher, 
				null, 
				null, --fix this for ConfNm
				null, 
				null, 
				null, 
				null,
				null, 
				null, 
				case 
				when ISDATE(txt6)=1 THEN cast(CAST(txt6 as DATE) as varchar(10))
				when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
			end, --fix this for PublicationDT
				'', --Abstract, 
				[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
				null, --fix this for URL
				RecordDate, 
				PRF_PERSON.PersonID, 
				RecordDate, 
				PRF_PERSON.PersonID 
		--select * 
		From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
		inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
		where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
		and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
		and FF_PUB.Expr5 in ('Thesis');
		------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
				PRF_PERSON.PersonID, 
				null, 
				[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
				null, 
				FF_PUB.txt3, --fix this - PubTitle
				case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
				end,
				null, 
				null, 
				null, 
				null,
				(case 
					when len(txt6) < 76 then txt6
					else REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt6,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH')
				end),  
				null, 
				null, 
				null, 
				(case 
        			when txt9 like 'http%'  or len(txt9) > 30 or txt9='' then 
        				case 
        					when txt8 like '%-%' then txt8
        				end
        			else txt9 
				end), -- Pagination -- Page     
				CAST(BibliographyID as varchar) + 
				CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end, 
				FF_PUB.txt4, --fix this - Publisher, 
				null, 
				null, --fix this for ConfNm
				null, 
				null, 
				null, 
				null,
				null, 
				null, 
				case 
				when ISDATE(txt5)=1 THEN cast(CAST(txt5 as DATE) as varchar(10))
				when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
			end, --fix this for PublicationDT
				'', --Abstract,  
				[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
				null, --fix this for URL
				RecordDate, 
				PRF_PERSON.PersonID, 
				RecordDate, 
				PRF_PERSON.PersonID 
		--select * 
		From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
		inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
		where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
		and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
		and FF_PUB.Expr5 in ('Paper Presented at a Meeting');
		------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
				PRF_PERSON.PersonID, 
				null, 
				[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
				null, 
				FF_PUB.txt4, --fix this - PubTitle
				case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
				end,
				null, 
				null, 
				null, 
				null,
				(case 
					when len(txt5) < 76 then txt5
					else REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt5,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH')
				end),  
				(case when txt3 like 'http%'  or len(txt3) > 30 then '' else txt3 end), -- Part of Volume #, 
				null, 
				null, 
				null, 
			CAST(BibliographyID as varchar) + 
			CASE WHEN Editors='' or Editors is null then '' else ' - Editors : ' + CAST(Editors as varchar) end + 
			CASE WHEN Annotation='' or Annotation is null then '' else ' - Annotation : ' + CAST(Annotation as varchar) end + 
			CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end, 
				FF_PUB.txt6, --fix this - Publisher, 
				null, 
				null, --fix this for ConfNm
				null, 
				null, 
				null, 
				null,
				null, 
				null, 
				case 
				when ISDATE(txt7)=1 THEN cast(CAST(txt7 as DATE) as varchar(10))
				when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
			end, --fix this for PublicationDT
				'', --Abstract,  
				[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
				null, --fix this for URL
				RecordDate, 
				PRF_PERSON.PersonID, 
				RecordDate, 
				PRF_PERSON.PersonID 
		--select * 
		From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
		inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
		where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
		and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
		and FF_PUB.Expr5 in ('Volume of a Book');
		------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
				PRF_PERSON.PersonID, 
				null, 
				[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
				null, 
				null, --fix this - PubTitle
				case 
					when FF_PUB.txt3 IS null OR LTRIM(RTRIM(FF_PUB.txt3))='' OR ISNUMERIC(FF_PUB.txt3) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt3		
				end,
				null, 
				null, 
				null, 
				null,
				(case 
					when len(txt4) < 76 then txt4
					else REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt4,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH')
				end), 
				null, 
				null, 
				(case when txt7 like 'http%'  or len(txt7) > 30 then '' else txt7 end), 
				(case when txt8 like 'http%'  or len(txt8) > 30 then '' else txt8 end), -- Pagination -- Page     
				CAST(BibliographyID as varchar) + 
			CASE WHEN Annotation='' or Annotation is null then '' else ' - Annotation : ' + CAST(Annotation as varchar) end +
			CASE WHEN len(txt5) < 36 then '' else ' - Patent # is : ' + CAST(txt5 as varchar) end +
				CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end, 
				FF_PUB.txt2, --fix this - Publisher, 
				null, 
				null, --fix this for ConfNm
				null, 
				null, 
				(case 
					when len(txt5) < 36 then txt5
					else substring(txt5,1,35)
			end) , --Patent # 
				null,
				null, 
				null, 
				case 
				when ISDATE(txt6)=1 THEN cast(CAST(txt6 as DATE) as varchar(10))
				when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
			end, --fix this for PublicationDT
				'', --Abstract,  
				[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
				null, --fix this for URL
				RecordDate, 
				PRF_PERSON.PersonID, 
				RecordDate, 
				PRF_PERSON.PersonID 
		From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
		inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
		where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
		and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
		and FF_PUB.Expr5 in ('Patent');
		--------------------------------------------------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
				PRF_PERSON.PersonID, 
				null, 
				[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
				null, 
				FF_PUB.txt3, --fix this - PubTitle
				case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
				end,
				null, 
				null, 
				null, 
				(case 
					when len(txt6) < 31 then txt6
					else substring(txt6,1,30)
				end), --Edition
				(case 
					when len(txt7) < 76 then txt7
					else REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt7,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH')
				end),  
				null, 
				null, 
				null, 
				(case when txt10 like 'http%'  or len(txt10) > 30 then '' else txt10 end), -- Pagination -- Page     
				CAST(BibliographyID as varchar) + 
			CASE WHEN Annotation='' or Annotation is null then '' else ' - Annotation : ' + CAST(Annotation as varchar) end +
			CASE WHEN txt4='' OR txt4 is null then '' else ' - Book Editors : ' + CAST(txt4 as varchar) end +
				CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end,  
				FF_PUB.txt8, --fix this - Publisher, 
				null, 
				null, --fix this for ConfNm
				null, 
				null, 
				null, 
				null,
				null, 
				null, 
				case 
				when ISDATE(txt9)=1 THEN cast(CAST(txt9 as DATE) as varchar(10))
				when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
			end, --fix this for PublicationDT
				'', --Abstract,   
				[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
				null, --fix this for URL
				RecordDate, 
				PRF_PERSON.PersonID, 
				RecordDate, 
				PRF_PERSON.PersonID 
		From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
		inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
		where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
		and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
		and FF_PUB.Expr5 in ('Contribution to a Book');
		--------------------------------------------------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
				PRF_PERSON.PersonID, 
				null, 
				[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
				null, 
				FF_PUB.txt2, --fix this - PubTitle
				case 
					when FF_PUB.txt3 IS null OR LTRIM(RTRIM(FF_PUB.txt3))='' OR ISNUMERIC(FF_PUB.txt3) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt3		
				end,
				null, 
				null, 
				null, 
				null,
				(case 
					when len(txt4) < 76 then txt4
					else REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt4,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH')
				end),  
				(case when txt7 like 'http%'  or len(txt7) > 30 then '' else txt7 end), -- Volume #
			null, -- Part of Volume #, 
				(case when txt8 like 'http%'  or len(txt8) > 30 then '' else txt8 end), -- Issue #
				(case when txt9 like 'http%'  or len(txt9) > 30 then '' else txt9 end), -- Pagination -- Page     
				CAST(BibliographyID as varchar) + 
				CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end,
				FF_PUB.txt5, --fix this - Publisher, 
				null, 
				null, --fix this for ConfNm
				null, 
				null, 
				null, 
				null,
				null, 
				null, 
				case 
				when ISDATE(txt6)=1 THEN cast(CAST(replace(replace(txt6,',', ' '),'  ',' ') as DATE) as varchar(10))
				when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
			end, --fix this for PublicationDT
				'', --Abstract,   
				[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
				null, --fix this for URL
				RecordDate, 
				PRF_PERSON.PersonID, 
				RecordDate, 
				PRF_PERSON.PersonID 
		From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
		inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
		where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
		and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
		and FF_PUB.Expr5 in ('Technical Report');
		--------------------------------------------------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
				PRF_PERSON.PersonID, 
				null, 
				[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
				null, 
				FF_PUB.txt8, --fix this - PubTitle
				case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
				end, 
				null, 
				null, 
				null, 
				(case 
					when len(txt3) < 31 then txt3
					else substring(txt3,1,30)
				end), --Edition
				(case 
					when len(txt4) < 76 then txt4
					else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt4,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
				end), --Place of Publication  
				null, 
				null, 
				(case when txt9 like 'http%'  or len(txt9) > 30 then '' else txt9 end), --Issue
				(case 
        			when txt7 like 'http%'  or len(txt7) > 30 or txt7='' then 
        				case 
        					when txt10 like 'http%'  or len(txt10) > 30 or txt10 ='' then ''
        					else txt10
        				end
        			else txt7 end), -- Pagination -- Page     
			CAST(BibliographyID as varchar) + 
			CASE WHEN Annotation='' or Annotation is null then '' else ' - Annotation : ' + CAST(Annotation as varchar) end +
			CASE WHEN Editors='' or Editors is null then '' else ' - Editors : ' + CAST(Editors as varchar(100)) end +
			CASE WHEN len(txt4)> 75 then ' - Place of Publication : ' + CAST(txt4 as varchar(125)) end +
				CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end,
				FF_PUB.txt5, --fix this - Publisher, 
				null, 
				null, --fix this for ConfNm
				null, 
				null, 
				null, 
				null,
				null, 
				null, 
			case 
				when ISDATE(txt6)=1 THEN cast(CAST(txt6 as DATE) as varchar(10))
				when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
			end, --fix this for PublicationDT
				'', --Abstract, 
				[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
				null, --fix this for URL
				RecordDate, 
				PRF_PERSON.PersonID, 
				RecordDate, 
				PRF_PERSON.PersonID 
		From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
		inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
		left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
		where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
		and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
		and FF_PUB.Expr5 in ('Chapter of a Book' );
		--------------------------------------------------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
					PRF_PERSON.PersonID, 
					null, 
					[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
					null, 
					null, --fix this - PubTitle
					case 
						when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
						else FF_PUB.txt2		
					end,
					null, 
					null, 
					null, 
					(case 
						when len(txt4) < 31 then txt4
						else substring(txt4,1,30)
					end),
					(case 
						when len(txt7) < 76 then txt7
						else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt7,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
					end), --Place of Publication,  
					(case when txt6 like 'http%'  or len(txt6) > 30 then '' else txt6 end), --Volume 
					null, 
					null, 
					null, 
					CAST(BibliographyID as varchar) + 
						CASE WHEN Annotation='' or Annotation is null then '' else ' - Annotation : ' + CAST(Annotation as varchar) end +
						CASE WHEN Editors='' or Editors is null then '' else ' - Editors : ' + CAST(Editors as varchar(100)) end +
						CASE WHEN len(txt7)> 75 then ' - Place of Publication : ' + CAST(txt7 as varchar(125)) end +
        					CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end,
					FF_PUB.txt3, --fix this - Publisher, 
					null, 
					null, --fix this for ConfNm
					null, 
					null, 
					null, 
					null,
					null, 
					null, 
					case 
						when ISDATE(txt5)=1 THEN cast(CAST(txt5 as DATE) as varchar(10))
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end, --fix this for PublicationDT
					'', --Abstract, 
					[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
					(case 
        					when txt6 like 'http%' or txt6 like 'www%' then txt6 
        					else case 
        						when txt4 like 'http%' or txt4 like 'www%'  then txt4
        						else case 
        							when txt8 like 'http%'  or txt8 like 'www%' then txt8
        							else null
        		     					 end
        	     					 end
        				end), --fix this for URL
					RecordDate, 
					PRF_PERSON.PersonID, 
					RecordDate, 
					PRF_PERSON.PersonID 
			From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
			inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
			where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
			and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
			and FF_PUB.Expr5 in ('Serial Article (E-media)' );
		--------------------------------------------------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
					PRF_PERSON.PersonID, 
					null, 
					[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
					null, 
					txt6, --fix this - PubTitle
					case 
						when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
						else FF_PUB.txt2		
					end,
					null, 
					null, 
					(case 
						when len(txt8) < 76 then txt8
						else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt8,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
					end), -- Conference Location
					(case 
						when len(txt9) < 31 then txt9
						else substring(txt9,1,30)
					end), -- Edition --Poster #
					(case 
						when len(txt8) < 76 then txt8
						else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt8,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
					end),  
					null, 
					null, 
					null, 
					null, 
					BibliographyID, 
					null, --fix this - Publisher, 
					null, 
					txt4, --fix this for ConfNm
					case 
						when ISDATE(txt7)=1 THEN cast(CAST(replace(replace(txt7,',', ' '),'  ',' ') as DATE) as varchar(10))
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end, --conf dt
					null, 
					(case 
						when len(txt5) < 36 then txt5
						else substring(txt5,1,35)
					end), 
					null,
					null, 
					null, 
					case 
						when ISDATE(txt7)=1 THEN cast(CAST(replace(replace(txt7,',', ' '),'  ',' ') as DATE) as varchar(10))
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end, --fix this for PublicationDT
					'', --Abstract, 
					[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
					null, --fix this for URL
					RecordDate, 
					PRF_PERSON.PersonID, 
					RecordDate, 
					PRF_PERSON.PersonID 
			From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
			inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
			where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
			and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
			and FF_PUB.Expr5 in ('Poster' );
		--------------------------------------------------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
					PRF_PERSON.PersonID, 
					null, 
					[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
					null, 
					FF_PUB.txt2, --fix this - PubTitle
					case 
						when FF_PUB.txt3 IS null OR LTRIM(RTRIM(FF_PUB.txt3))='' OR ISNUMERIC(FF_PUB.txt3) = 1 then FF_PUB.noAuthorString	
						else FF_PUB.txt3		
					end,
					null, 
					null, 
					null, 
					(case 
						when len(txt7) < 31 then txt7
						else substring(txt7,1,30)
					end),
					(case 
						when len(txt4) < 76 then txt4
						else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt4,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
					end),  
					(case when txt7 like 'http%'  or len(txt7) > 30 then '' else txt7 end), -- Volume #
					null, -- Part of Volume #, 
					(case when txt8 like 'http%'  or len(txt8) > 30 then '' else txt8 end), -- Issue #
					(case when txt9 like 'http%'  or len(txt9) > 30 then '' else txt9 end), -- Pagination -- Page     
					CAST(BibliographyID as varchar) + 
					CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end,
					FF_PUB.txt5, --fix this - Publisher, 
					null, 
					null, --fix this for ConfNm
					null, 
					null, 
					(case 
						when len(txt8) < 36 then txt8
						else substring(txt8,1,35)
					end), 
					null,
					null, 
					null, 
					case 
						when ISDATE(txt6)=1 THEN cast(CAST(replace(replace(txt6,',', ' '),'  ',' ') as DATE) as varchar(10))
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end, --fix this for PublicationDT
					'', --Abstract, 
					[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
					null, --fix this for URL
					RecordDate, 
					PRF_PERSON.PersonID, 
					RecordDate, 
					PRF_PERSON.PersonID 
			From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
			inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
			where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
			and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
			and FF_PUB.Expr5 in ('Scientific Report' );

		--------------------------------------------------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
					PRF_PERSON.PersonID, 
					null, 
					[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
					null, 
					null, --fix this - PubTitle
					case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
					end, 
					null, 
					null, 
					null, 
					null,
					(case 
						when len(txt5) < 76 then txt5
						else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt5,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
					end),  
					null, 
					null, 
					null, 
					(case when txt4 like 'http%'  or len(txt4) > 30 then '' else txt4 end), -- Pagination -- Page     
					CAST(BibliographyID as varchar) + 
					CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end, 
					FF_PUB.txt5, --fix this - Publisher, 
					null, 
					null, --fix this for ConfNm
					null, 
					null, 
					null, 
					null,
					null, 
					null, 
					case 
						when ISDATE(txt3)=1 THEN cast(CAST(replace(replace(txt3,',', ' '),'  ',' ') as DATE) as varchar(10))
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end, --fix this for PublicationDT
					'', --Abstract,  
					[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
					null, --fix this for URL
					RecordDate, 
					PRF_PERSON.PersonID, 
					RecordDate, 
					PRF_PERSON.PersonID 
			From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
			inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
			where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
			and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
			and FF_PUB.Expr5 in ('Manuscript' );

		--------------------------------------------------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
					PRF_PERSON.PersonID, 
					null, 
					[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
					null, 
					FF_PUB.txt13, --fix this - PubTitle
					case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
					end, 
					null, 
					txt4, 
					(case 
						when len(txt8) < 76 then txt8
						else REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt8,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH')
					end), --Conference Location 
					null,
					(case 
						when len(txt9) < 76 then txt9
						else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt9,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
					end),  
					null, 
					null, 
					null, 
					(case when txt12 like 'http%'  or len(txt12) > 30 then '' else txt12 end), -- Pagination -- Page     
					CAST(BibliographyID as varchar) + 
					CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end, 
					txt10, --fix this - Publisher, 
					null, 
					txt6, --fix this for ConfNm
					case 
						when ISDATE(txt7)=1 THEN 
							case 
								when cast(CAST(replace(replace(txt7,',', ' '),'  ',' ') as DATE) as varchar(10)) < '2050-01-01' then cast(CAST(replace(replace(txt7,',', ' '),'  ',' ') as DATE) as varchar(10))
							end
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end, --fix this for Conf DT 
					null, 
					null, 
					null,
					null, 
					null, 
					case 
						when ISDATE(txt11)=1 THEN 
							case 
								when cast(CAST(replace(replace(txt11,',', ' '),'  ',' ') as DATE) as varchar(10)) < '2050-01-01' then cast(CAST(replace(replace(txt11,',', ' '),'  ',' ') as DATE) as varchar(10))
							end
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end, --fix this for PublicationDT
					'', --Abstract,   
					[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
					null, --fix this for URL
					RecordDate, 
					PRF_PERSON.PersonID, 
					RecordDate, 
					PRF_PERSON.PersonID 
			From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
			inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
			where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
			and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
			and FF_PUB.Expr5 in ('Abstract' );

		--------------------------------------------------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
					PRF_PERSON.PersonID, 
					null, 
					[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
					null, 
					case 
						when FF_PUB.txt6='' then
							case 
								when FF_PUB.txt4='' then ''
								else FF_PUB.txt4
							end
						else FF_PUB.txt6
					end, --fix this - PubTitle
					case 
					when FF_PUB.txt3 IS null OR LTRIM(RTRIM(FF_PUB.txt3))='' OR ISNUMERIC(FF_PUB.txt3) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt3		
					end,
					null, 
					FF_PUB.txt5, 
					case 
						when len(txt9) < 76 then txt9
						else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt9,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
					end, --Conference Location
					null,
					(case 
						when txt13='' then
							case 
								when len(txt10) < 76 then txt10
								else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt10,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
							end	
						when len(txt13) < 76 then txt13
						else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt13,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
					end), --Place of Publication  
					null, 
					null, 
					null, 
					null, 
					CAST(BibliographyID as varchar) + 
					CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end, 
					txt11, --fix this - Publisher, 
					null, 
					txt7, --fix this for ConfNm
					case 
						when ISDATE(txt8)=1 THEN 
							case 
								when cast(CAST(replace(replace(txt8,',', ' '),'  ',' ') as DATE) as varchar(10)) < '2050-01-01' then cast(CAST(replace(replace(txt8,',', ' '),'  ',' ') as DATE) as varchar(10))
							end
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end, --Conference Date 
					null, 
					null, 
					null,
					null, 
					null, 
					case 
						when ISDATE(txt12)=1 THEN 
							case 
								when cast(CAST(replace(replace(txt12,',', ' '),'  ',' ') as DATE) as varchar(10)) < '2050-01-01' then cast(CAST(replace(replace(txt12,',', ' '),'  ',' ') as DATE) as varchar(10))
							end
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end, --fix this for PublicationDT
					'', --Abstract,
					case 
						when [ProfilesRNS].[dbo].[Publications_Author](BibliographyID) = '' then txt2
						else [ProfilesRNS].[dbo].[Publications_Author](BibliographyID)
					end,
					null, --fix this for URL
					RecordDate, 
					PRF_PERSON.PersonID, 
					RecordDate, 
					PRF_PERSON.PersonID 
			From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
			inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
			where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
			and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
			and FF_PUB.Expr5 in ('Conference Paper' );
		--------------------------------------------------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
					PRF_PERSON.PersonID, 
					null, 
					[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
					null, 
					null, --fix this - PubTitle
					case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
					end,
					null, 
					null, 
					null, 
					null,
					(case 
						when len(txt3) < 76 then txt3
						else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt3,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
					end), -- Place of Publication 
					null, 
					null, 
					null, 
					null, 
					CAST(BibliographyID as varchar) + 
					CASE WHEN txt6='' or txt6 is null then '' else ' - Availablity : ' + CAST(txt6 as varchar(max)) end +
					CASE WHEN txt7='' or txt7 is null then '' else ' - Language : ' + CAST(txt7 as varchar(max)) end +
					CASE WHEN txt8='' or txt8 is null then '' else ' - Notes : ' + CAST(txt8 as varchar(max)) end +
					CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end, 
					txt4, --fix this - Publisher, 
					null, 
					null, --fix this for ConfNm
					null, 
					null, 
					null, 
					null,
					null, 
					null, 
					case 
						when ISDATE(txt5)=1 THEN 
							case 
								when cast(CAST(replace(replace(txt5,',', ' '),'  ',' ') as DATE) as varchar(10)) < '2050-01-01' then cast(CAST(replace(replace(txt5,',', ' '),'  ',' ') as DATE) as varchar(10))
							end
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end, --fix this for PublicationDT
					'', --Abstract, 
					[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
					(case 
 			       			when txt3 like 'http%' or (txt3 like 'www%' and len(txt3)>3) then txt3
 			       			else case 
 			       				when txt6 like 'http%'  or txt6 like 'www%' then txt6
 			       				 end
 						   end), --fix this for URL
					RecordDate, 
					PRF_PERSON.PersonID, 
					RecordDate, 
					PRF_PERSON.PersonID 
			From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
			inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
			where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
			and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
			and FF_PUB.Expr5 in ('Homepage (E-media)' );

		--------------------------------------------------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
					PRF_PERSON.PersonID, 
					null, 
					[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
					null, 
					case 
            				when ISNUMERIC(txt5)=1 then txt4
					else replace(rtrim(ltrim(txt5)),'',txt4)
					end , --fix this - PubTitle
					case 
					when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
					else FF_PUB.txt2		
					end, 
					null, 
					null, 
					null, 
					null,
					(case 
						when len(txt4) < 76 then txt4
						else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt4,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
					end),  --Place of Publication
					null, 
					null, 
					null, 
					(case 
						when txt8 like '%-%' then txt8
						else case
							when txt9 like '%-%' then txt9
							 end
					end), -- Pagination -- Page     
					CAST(BibliographyID as varchar) +  
					CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end, 
					txt5, --fix this - Publisher, 
					txt3, --Secondary Authors
					null, --fix this for ConfNm
					null, 
					null, 
					null, 
					null,
					null, 
					null, 
					case 
						when ISDATE(txt6)=1 THEN 
							case 
								when cast(CAST(replace(replace(txt6,',', ' '),'  ',' ') as DATE) as varchar(10)) < '2050-01-01' then cast(CAST(replace(replace(txt6,',', ' '),'  ',' ') as DATE) as varchar(10))
							end
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end, --fix this for PublicationDT
					'', --Abstract, 
					[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
					null, --fix this for URL
					RecordDate, 
					PRF_PERSON.PersonID, 
					RecordDate, 
					PRF_PERSON.PersonID 
			From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
			inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
			where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
			and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
			and FF_PUB.Expr5 in ('Monograph' );

		--------------------------------------------------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
					PRF_PERSON.PersonID, 
					null, 
					[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
					null, 
					null , --fix this - PubTitle
					case 
						when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
						else FF_PUB.txt2		
					end, 
					null, 
					null, 
					case 
						when len(txt5) < 76 then txt5
						else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt5,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
					end, --Conference Location
					null,
					(case 
						when len(txt6) < 76 then txt6
						else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt6,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
					end),  --Place of publication
					null, 
					null, 
					null, 
					(case when txt9 like 'http%'  or len(txt9) > 30 then '' else txt9 end), -- Pagination -- Page     
					CAST(BibliographyID as varchar) + 
					CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end, 
					txt7, --fix this - Publisher, 
					null, 
					txt3, --fix this for ConfNm
					case 
						when ISDATE(txt4)=1 THEN 
							case 
								when cast(CAST(replace(replace(txt4,',', ' '),'  ',' ') as DATE) as varchar(10)) < '2050-01-01' then cast(CAST(replace(replace(txt4,',', ' '),'  ',' ') as DATE) as varchar(10))
							end
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end, --Conf Dates
					null, 
					null, 
					null,
					null, 
					null, 
					case 
						when ISDATE(txt8)=1 THEN 
							case 
								when cast(CAST(replace(replace(txt8,',', ' '),'  ',' ') as DATE) as varchar(10)) < '2050-01-01' then cast(CAST(replace(replace(txt8,',', ' '),'  ',' ') as DATE) as varchar(10))
							end
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end, --fix this for PublicationDT
					'', --Abstract,  
					[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
					null, --fix this for URL
					RecordDate, 
					PRF_PERSON.PersonID, 
					RecordDate, 
					PRF_PERSON.PersonID 
			From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
			inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
			where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
			and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
			and FF_PUB.Expr5 in ('Conference Proceedings' );

		--------------------------------------------------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
					PRF_PERSON.PersonID, 
					null, 
					[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
					null, 
					null, --fix this - PubTitle
					case 
						when FF_PUB.txt4 IS null OR LTRIM(RTRIM(FF_PUB.txt4))='' OR ISNUMERIC(FF_PUB.txt4) = 1 then FF_PUB.noAuthorString	
						else FF_PUB.txt4		
					end, 
					null, 
					null, 
					null, 
					null,
					null, --Place of Publication  
					null, 
					(case when txt6 like 'http%'  or len(txt6) > 30 then '' else txt6 end), -- Volume 
					(case when txt7 like 'http%'  or len(txt7) > 30 then '' else txt7 end), -- Issue
					(case when txt8 like 'http%'  or len(txt8) > 30 then '' else txt8 end), -- Pagination -- Page     
					CAST(BibliographyID as varchar) + 
					CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end,  
					txt2, --fix this - Publisher, 
					null, 
					null, --fix this for ConfNm
					null, 
					null, 
					null, 
					null,
					null, 
					null, 
					case 
						when ISDATE(txt3)=1 THEN 
							case 
								when cast(CAST(replace(replace(txt3,',', ' '),'  ',' ') as DATE) as varchar(10)) < '2050-01-01' then cast(CAST(replace(replace(txt3,',', ' '),'  ',' ') as DATE) as varchar(10))
							end
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end, --fix this for PublicationDT
					'', --Abstract, 
					[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
					null, --fix this for URL
					RecordDate, 
					PRF_PERSON.PersonID, 
					RecordDate, 
					PRF_PERSON.PersonID 
			From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
			inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
			where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
			and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
			and FF_PUB.Expr5 in ('Letter to Editor' );
		--------------------------------------------------------------------------------------------
		insert into [ProfilesStaging].[dbo].[Load_Publications]
		select	NEWID(), 
					PRF_PERSON.PersonID, 
					null, 
					[ProfilesStaging].[Profile.Data].[get_prf_cat] (ISNULL(FF_PUB.Expr5,'')), 
					null, 
					null, --fix this - PubTitle
					case 
						when FF_PUB.txt2 IS null OR LTRIM(RTRIM(FF_PUB.txt2))='' OR ISNUMERIC(FF_PUB.txt2) = 1 then FF_PUB.noAuthorString	
						else FF_PUB.txt2		
					end,
					null, 
					null, 
					null, 
					(case 
						when len(txt3) < 31 then txt3
						else substring(txt3,1,30)
					end), --Edition
					(case 
						when len(txt5) < 76 then txt5
						else SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(txt5,'  ',' '),'University of Arkansas for Medical Sciences','UAMS'),' ,',','),'Task Force','TF'),'Arkansas Childrens Hospital','ACH'),1,75)
					end),  --Place of publication 
					null, 
					null, 
					null, 
					(case when txt8 like 'http%'  or len(txt8) > 30 then '' else txt8 end), -- Pagination -- Page     
					CAST(BibliographyID as varchar) + 
					CASE WHEN txt15='' or txt15 is null then '' else ' - ' + CAST(txt15 as varchar) end, 
					txt6, --fix this - Publisher, 
					txt4, --Secondary Author
					null, --fix this for ConfNm
					null, 
					null, 
					null, 
					null,
					null, 
					null, 
					case 
						when ISDATE(txt7)=1 THEN 
							case 
								when cast(CAST(replace(replace(txt7,',', ' '),'  ',' ') as DATE) as varchar(10)) < '2050-01-01' then cast(CAST(replace(replace(txt7,',', ' '),'  ',' ') as DATE) as varchar(10))
							end
						when ISDATE(Fiscalyear)=1 THEN cast(CAST(Fiscalyear as DATE) as varchar(10))
					end, --fix this for PublicationDT
					'', --Abstract,  
					[ProfilesRNS].[dbo].[Publications_Author](BibliographyID),
					(case 
 			       			when txt5 like 'http%' or (txt5 like 'www%' and len(txt5)>3) then txt5
 			       			else case 
 			       				when txt10 like 'http%'  or txt10 like 'www%' then txt10
 			       				 end
 						   end), --fix this for URL
					RecordDate, 
					PRF_PERSON.PersonID, 
					RecordDate, 
					PRF_PERSON.PersonID 
			From [HOSP_SQL1].[FacFac].[dbo].[vTRI_Publications] FF_PUB
			inner join [ProfilesRNS].[Profile.Data].[Person] PRF_PERSON on PRF_PERSON.PersonID=cast(cast(FF_PUB.Expr1 as int) as varchar)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.PubMed.General] PRF_PUBS on [ProfilesRNS].dbo.RemoveSpecialChars(FF_PUB.txt2)=[ProfilesRNS].dbo.RemoveSpecialChars(PRF_PUBS.ArticleTitle)
			left outer join [ProfilesRNS].[Profile.Data].[Publication.Person.Include] PRF_PUBS_AUTH on PRF_PUBS.PMID=PRF_PUBS_AUTH.PMID
			where FF_PUB.txt2 is not null and FF_PUB.Expr1 is not null and PRF_PUBS.ArticleTitle is null and PRF_PUBS_AUTH.PMID is null
			and ISNUMERIC(FF_PUB.expr1)=1 and ISNUMERIC(FF_PUB.sapid)=1
			and FF_PUB.Expr5 in ('Monographs (E-media)' );
		--------------------------------------------------------------------------------------------
			update A
			set Authors=B.Lastname+', '+B.Firstname
			From [ProfilesStaging].[dbo].[Load_Publications] A
			inner join [ProfilesRNS].[Profile.Data].[Person] B on A.PersonID=B.PersonID
			where ltrim(rtrim(A.Authors))='';
		
		BEGIN
			with cleanup as 
			(select ROW_NUMBER() over 
			(PARTITION by PersonId, HmsPubCategory, PubTitle, ArticleTitle, ConfEditors, ConfLoc, Edition,  
			PlaceofPub, VolNum, PartVolPub, IssuePub, PaginationPub, Publisher, SecondaryAuthors, 
			ConfNm, ConfDTS, ContractNum, NewspaperCol, NewspaperSect, PublicationDT, Authors, CreatedBy, 
			UpdatedBy order by PersonId, HmsPubCategory, PubTitle, ArticleTitle, ConfEditors, ConfLoc, Edition,  
			PlaceofPub, VolNum, PartVolPub, IssuePub, PaginationPub, Publisher, SecondaryAuthors, 
			ConfNm, ConfDTS, ContractNum, NewspaperCol, NewspaperSect, PublicationDT, Authors, CreatedBy, 
			UpdatedBy) as rownumber,* 
			from [ProfilesStaging].[dbo].[Load_Publications]) delete From cleanup where rownumber > 1;
		END;
	
		
END;

GO