USE [ProfilesStaging]
GO

/****** Object:  StoredProcedure [dbo].[Load_GrantRecipients]    Script Date: 05/14/2014 13:06:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Load_GrantRecipients] AS 
BEGIN 
		BEGIN 
			truncate table [ProfilesStaging].dbo.Grant_Recipients;
		END;
		BEGIN
		select * into #cache_grant_recipients from 		
		(select Lower.PRN, Lower.SAPID, Lower.Start_Date, Upper.Stop_Date, (case when Upper.Role='Principal Investigator' then 1 else 0 end) IsPrincipalInvestigator from 
		(select	MIN([ARIAGrant].StartDate) Start_Date, 
				[ARIAGrant].PRN,
				[AriaGrantRole].SAPID, 
				[AriaGrantRole].Role
				From	(select ROW_NUMBER() over (partition by PRN order by ARIARecordID desc, StopDate desc) as rownum, * 
						From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] A
						where A.ProjectStatus = 'Awarded' 
						and not exists 
		    				(select * 
							from	(select * 
									From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] 
		    						where ProjectStatus = 'Awarded' 
		    						and Granttype in ('Other') 
		    						and Title like '%Recruit%'
		    						union
		    						select * 
		    						From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant]
		    						where ProjectStatus = 'Awarded' 
		    						and Granttype='Recruitment') B 
							where A.ARIAGrantID=B.ARIAGrantID)) ARIAGrant
				inner join [HOSP_SQL1].[FacFac].[dbo].[vAriaGrantRole] AriaGrantRole on ARIAGrant.PRN=ARIAGrantRole.PRN and ARIAGrant.ARIARecordID=ARIAGrantRole.ARIARecordID
				where ARIAGrant.rownum > 1		 	
				group by [ARIAGrant].PRN,
				[AriaGrantRole].SAPID, 
				[AriaGrantRole].Role) Lower
		INNER JOIN 
		(select	MAX([ARIAGrant].StopDate) Stop_Date, 
				[ARIAGrant].PRN,
				[AriaGrantRole].SAPID, 
				[AriaGrantRole].Role
				From	(select ROW_NUMBER() over (partition by PRN order by ARIARecordID desc, StopDate desc) as rownum, * 
						From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] A
						where A.ProjectStatus = 'Awarded' 
						and not exists 
		    				(select * 
							from	(select * 
									From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] 
		    						where ProjectStatus = 'Awarded' 
		    						and Granttype in ('Other') 
		    						and Title like '%Recruit%'
		    						union
		    						select * 
		    						From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant]
		    						where ProjectStatus = 'Awarded' 
		    						and Granttype='Recruitment') B 
							where A.ARIAGrantID=B.ARIAGrantID)) ARIAGrant
				inner join [HOSP_SQL1].[FacFac].[dbo].[vAriaGrantRole] AriaGrantRole on ARIAGrant.PRN=ARIAGrantRole.PRN and ARIAGrant.ARIARecordID=ARIAGrantRole.ARIARecordID
				where ARIAGrant.rownum > 1		 	
				group by [ARIAGrant].PRN,
				[AriaGrantRole].SAPID, 
				[AriaGrantRole].Role) Upper on Lower.PRN=UPPER.PRN and Lower.SAPID=Upper.SAPID
				group by Lower.PRN, Lower.SAPID, Lower.Start_Date, Upper.Stop_Date, (case when Upper.Role='Principal Investigator' then 1 else 0 end)) GrantAffiliation;
		END;
		
		BEGIN 
		with a as (
		select ROW_NUMBER() over (PARTITION by PRN, SAPID, Start_Date, Stop_date 
		                          order by PRN, SAPID, IsPrincipalInvestigator desc) as rownum, *  From #cache_grant_recipients) insert into [ProfilesStaging].dbo.Grant_Recipients select PRN, SAPID, Start_Date, Stop_date,IsPrincipalInvestigator from a
		                          where rownum < 2
		                          order by PRN, SAPID, Start_Date, Stop_date;
		END;
END; 


GO
