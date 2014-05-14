USE [ProfilesRNS]
GO

/****** Object:  StoredProcedure [Profile.Data].[LoadGrantsData]    Script Date: 05/14/2014 14:54:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [Profile.Data].[LoadGrantsData] (@REFRESH BIT=0 )
AS 
    BEGIN
        SET NOCOUNT ON;	

	-- Start Transaction. Log load failures, roll back transaction on error.
        BEGIN TRY	 
          BEGIN TRAN
           
            DECLARE @ErrMsg NVARCHAR(4000) ,
                @ErrSeverity INT
		BEGIN
			EXECUTE [ProfilesStaging].[dbo].[Load_GrantRecipients];
		END;
		IF @REFRESH = 1
		  BEGIN
		    truncate table [Profile.Data].[Grant.Information]; 
		    truncate table [Profile.Data].[Grant.AffiliatedPeople];
   
		    INSERT INTO [Profile.Data].[Grant.Information] (
		      [ARIAGrantID],
		      [ARIARecordID],
		      [StartDate],
		      [EndDate],
		      [GrantTitle],
		      [GrantAmount],
		      [PRJID],
		      [IsActive]
		    )
		    select	[ARIAGrant].ARIAGrantID, 
		    		[ARIAGrant].ARIARecordID, 
		    		[ARIAGrant].StartDate, 
		    		[ARIAGrant].StopDate, 
		    		[ProfilesStaging].dbo.ReplaceSpecialChars([ARIAGrant].FundName) + ' - ' + [ProfilesStaging].dbo.ReplaceSpecialChars([ARIAGrant].Title) + (CASE WHEN ISNULL([ARIAGrant].AwardNumber,'')='' OR [ARIAGrant].AwardNumber='' OR [ARIAGrant].AwardNumber='0' OR [ARIAGrant].AwardNumber='01' OR [ARIAGrant].AwardNumber='0' OR [ARIAGrant].AwardNumber='N/A' or [ARIAGrant].AwardNumber='na' THEN '' ELSE ' - Award Number: ' + ARIAGrant.AwardNumber END) + (CASE WHEN [ARIAGrant].DirectCostsTotal > 0 THEN ' - Total direct costs: $' + CAST([ProfilesStaging].[dbo].[fn_FormatWithCommas](ARIAGrant.DirectCostsTotal) as VARCHAR(20)) ELSE '' END), 
		    		[ARIAGrant].TotalAmount, 
		    		[ARIAGrant].PRN, 
		    		1  
		    From (select ROW_NUMBER() over (partition by PRN order by ARIARecordID desc, StopDate desc) as rownum, * 
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
		    					and Granttype='Recruitment'
		    					union
		    					select * 
		    					From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant]
		    					where ProjectStatus = 'Awarded' 
		    					and GrantCategory='IPA') B 
		    		 	where A.ARIAGrantID=B.ARIAGrantID)) ARIAGrant
		    where ARIAGrant.rownum < 2;

		    INSERT INTO [Profile.Data].[Grant.AffiliatedPeople] (
		      [GrantID],
		      [PersonID],
		      [SAPID],
		      [IsPrincipalInvestigator],
		      [Excluded]
		    )                                              
		    select A.GrantID,C.PersonId, B.SAPID,
		    (SELECT CASE WHEN B.Role='Principal Investigator' THEN 1 ELSE 0 END),'0'  from [Profile.Data].[Grant.Information] A
		    inner join [HOSP_SQL1].[FacFac].[dbo].[vAriaGrantRole] B on A.ARIARECORDID=B.ARIARecordID and A.PRJID=B.PRN
		    inner join (select	*
		    		From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] A 
		    		where ProjectStatus = 'Awarded' 
		    		and 
		    		not exists (	select * 
		    						from	(select * 
		    								From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] 
		    								where ProjectStatus = 'Awarded' 
		    								and Granttype in ('Other') 
		    								and Title like '%Recruit%'
		    								union
		    								select * 
											From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant]
											where ProjectStatus = 'Awarded' 
											and Granttype='Recruitment'
		    								union
		    								select * 
											From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant]
											where ProjectStatus = 'Awarded' 
											and GrantCategory='IPA') B 
						where A.ARIAGrantID=B.ARIAGrantID)) X on B.ARIARecordID=X.ARIARecordID and A.PRJID=X.PRN
		    inner join [ProfilesRNS].[User.Account].[User] C on B.SAPID=RIGHT('00000000'+ISNULL(C.internalusername,''),8)
		    where X.ProjectStatus='Awarded'
		    and B.SAPID  <> 'Non-UAMS'
		    and C.PersonID IS NOT NULL;
		    
		    BEGIN
		    	INSERT INTO [Profile.Data].[Grant.AffiliatedPeople] 
					([GrantID],
					[PersonID],
					[SAPID],
					[IsPrincipalInvestigator],
					[Excluded])     
				select	GI.GrantID,
						CAST(GR.SAPID AS INT),
						GR.SAPID, 
						GR.IsPrincipalInvestigator,
						0
				FROM	[ProfilesStaging].dbo.Grant_Recipients GR
				inner 
				join	[Profile.Data].[Grant.Information] GI on GR.PRN=GI.PRJID
				inner 
				join	[Profile.Data].[Person] P on RIGHT('00000000'+ISNULL(P.internalusername,''),8)=GR.SAPID
				where
				not 
				exists	(select * 
						From	[Profile.Data].[Grant.AffiliatedPeople] GA
						where	GA.GrantID=GI.GrantID and GA.SAPID=GR.SAPID)
				order by GR.SAPID;
		    END;

		    -- Remove duplicate values of grant affiliations
		    with a as
		   (select ROW_NUMBER() over (PARTITION by GrantId, PersonId, SapID, IsPrincipalInvestigator order by excluded desc) as rownum, *
		    from [Profile.Data].[Grant.AffiliatedPeople]) delete From a where rownum > 1;

			SET IDENTITY_INSERT [Profile.Data].[Grant.Information] ON;
			insert 
		    into	[Profile.Data].[Grant.Information] (GrantID,
														ARIAGrantID,
														ARIARecordID,
														StartDate,
														EndDate,
														GrantTitle,
														PRJID,
														GrantAmount,
														IsActive)
		    select	CAST(GrantId as int)
					,CAST(ARIAGrantID as int)
					,CAST(ARIARecordID as int)
					,CAST(StartDate as datetime)
					,CAST(EndDate as datetime)
					,[GrantTitle]
					,[PRN]
					,(CASE WHEN GrantAmount='' THEN '0' ELSE GrantAmount END)
					,1
			FROM	[ProfilesStaging].[dbo].[KL2_T32_Grant_Info];
			
			insert into [Profile.Data].[Grant.AffiliatedPeople]
			select * from [ProfilesStaging].[dbo].[KL2_T32_Grant_Affiliation];
			SET IDENTITY_INSERT [Profile.Data].[Grant.Information] OFF;

		  END;  
		ELSE
		  BEGIN
		    delete from [Profile.Data].[Grant.AffiliatedPeople] where  (Excluded is null or Excluded='0');

		    -- Add new Records of Existing Grants
		    INSERT INTO [Profile.Data].[Grant.Information] (
		      [ARIAGrantID],
		      [ARIARecordID],
		      [StartDate],
		      [EndDate],
		      [GrantTitle],
		      [GrantAmount],
		      [PRJID],
		      [IsActive]
		    )
		    select	[ARIAGrant].ARIAGrantID, 
				[ARIAGrant].ARIARecordID, 
				[ARIAGrant].StartDate, 
				[ARIAGrant].StopDate, 
				[ProfilesStaging].dbo.ReplaceSpecialChars([ARIAGrant].FundName) + ' - ' + [ProfilesStaging].dbo.ReplaceSpecialChars([ARIAGrant].Title) + (CASE WHEN ISNULL([ARIAGrant].AwardNumber,'')='' OR [ARIAGrant].AwardNumber='' OR [ARIAGrant].AwardNumber='0' OR [ARIAGrant].AwardNumber='01' OR [ARIAGrant].AwardNumber='0' OR [ARIAGrant].AwardNumber='N/A' or [ARIAGrant].AwardNumber='na' THEN '' ELSE ' - Award Number: ' + ARIAGrant.AwardNumber END) + (CASE WHEN [ARIAGrant].DirectCostsTotal > 0 THEN ' - Total direct costs: $' + CAST([ProfilesStaging].[dbo].[fn_FormatWithCommas](ARIAGrant.DirectCostsTotal) as VARCHAR(20)) ELSE '' END), 
				[ARIAGrant].TotalAmount, 
				[ARIAGrant].PRN, 
		    		1
		    FROM (select	*
		    		From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] A 
		    		where ProjectStatus = 'Awarded' 
		    		and 
		    		not exists (	select * 
		    						from	(select * 
		    								From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] 
		    								where ProjectStatus = 'Awarded' 
		    								and Granttype in ('Other') 
		    								and Title like '%Recruit%'
		    								union
		    								select * 
											From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant]
											where ProjectStatus = 'Awarded' 
											and Granttype='Recruitment'
		    								union
		    								select * 
											From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant]
											where ProjectStatus = 'Awarded' 
											and GrantCategory='IPA') B 
						where A.ARIAGrantID=B.ARIAGrantID)) ARIAGrant
		    inner join [Profile.Data].[Grant.Information] GrantInformation 
		    on ARIAGrant.PRN=GrantInformation.PRJID
		    and ARIAGrant.ARIARecordID > GrantInformation.ARIARecordID 
		    WHERE [ARIAGrant].ProjectStatus = 'Awarded';
		    
		    -- Add Records of Grants that did not exist
		    INSERT INTO [Profile.Data].[Grant.Information] (
		      [ARIAGrantID],
		      [ARIARecordID],
		      [StartDate],
		      [EndDate],
		      [GrantTitle],
		      [GrantAmount],
		      [PRJID],
		      [IsActive]
		    )
		    select	[ARIAGrant].ARIAGrantID, 
		    		[ARIAGrant].ARIARecordID, 
		    		[ARIAGrant].StartDate, 
		    		[ARIAGrant].StopDate, 
		    		[ProfilesStaging].dbo.ReplaceSpecialChars([ARIAGrant].FundName) + ' - ' + [ProfilesStaging].dbo.ReplaceSpecialChars([ARIAGrant].Title) + (CASE WHEN ISNULL([ARIAGrant].AwardNumber,'')='' OR [ARIAGrant].AwardNumber='' OR [ARIAGrant].AwardNumber='0' OR [ARIAGrant].AwardNumber='01' OR [ARIAGrant].AwardNumber='0' OR [ARIAGrant].AwardNumber='N/A' or [ARIAGrant].AwardNumber='na' THEN '' ELSE ' - Award Number: ' + ARIAGrant.AwardNumber END) + (CASE WHEN [ARIAGrant].DirectCostsTotal > 0 THEN ' - Total direct costs: $' + CAST([ProfilesStaging].[dbo].[fn_FormatWithCommas](ARIAGrant.DirectCostsTotal) as VARCHAR(20)) ELSE '' END), 
		    		[ARIAGrant].TotalAmount, 
		    		[ARIAGrant].PRN, 
		    		1
		    FROM (	select	*
		    		From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] A 
		    		where ProjectStatus = 'Awarded' 
		    		and 
		    		not exists (	select * 
		    						from	(select * 
		    								From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] 
		    								where ProjectStatus = 'Awarded' 
		    								and Granttype in ('Other') 
		    								and Title like '%Recruit%'
		    								union
		    								select * 
											From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant]
											where ProjectStatus = 'Awarded' 
											and Granttype='Recruitment'
		    								union
		    								select * 
											From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant]
											where ProjectStatus = 'Awarded' 
											and GrantCategory='IPA') B 
						where A.ARIAGrantID=B.ARIAGrantID)) ARIAGrant
		    WHERE NOT EXISTS  
		    (select * from [Profile.Data].[Grant.Information] GrantInformation
		    where ARIAGrant.PRN=GrantInformation.PRJID)
		    AND [ARIAGrant].ProjectStatus = 'Awarded';
		    
		    -- Remove duplicate values of grants
		    with a as
		    (select ROW_NUMBER() over (PARTITION by PRJID order by ARIARecordID desc, EndDate desc) as rownum, *
		    from [Profile.Data].[Grant.Information]) delete from a where rownum > 1;

		    INSERT INTO [Profile.Data].[Grant.AffiliatedPeople] (
		      [GrantID],
		      [PersonID],
		      [SAPID],
		      [IsPrincipalInvestigator],
		      [Excluded]
		    )                                              
		    select A.GrantID,C.PersonId, B.SAPID,
		    (SELECT CASE WHEN B.Role='Principal Investigator' THEN 1 ELSE 0 END),'0'  from [Profile.Data].[Grant.Information] A
		    inner join [HOSP_SQL1].[FacFac].[dbo].[vAriaGrantRole] B on A.ARIARECORDID=B.ARIARecordID and A.PRJID=B.PRN
		    inner join (select	*
		    		From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] A 
		    		where ProjectStatus = 'Awarded' 
		    		and 
		    		not exists (	select * 
		    						from	(select * 
		    								From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] 
		    								where ProjectStatus = 'Awarded' 
		    								and Granttype in ('Other') 
		    								and Title like '%Recruit%'
		    								union
		    								select * 
											From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant]
											where ProjectStatus = 'Awarded' 
											and Granttype='Recruitment'
		    								union
		    								select * 
											From [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant]
											where ProjectStatus = 'Awarded' 
											and GrantCategory='IPA') B 
						where A.ARIAGrantID=B.ARIAGrantID)) X on B.ARIARecordID=X.ARIARecordID and A.PRJID=X.PRN
		    inner join [ProfilesRNS].[User.Account].[User] C on B.SAPID=RIGHT('00000000'+ISNULL(C.internalusername,''),8)
		    where X.ProjectStatus='Awarded'
		    and B.SAPID  <> 'Non-UAMS'
		    and C.PersonID IS NOT NULL;

		    BEGIN
		    	INSERT INTO [Profile.Data].[Grant.AffiliatedPeople] 
					([GrantID],
					[PersonID],
					[SAPID],
					[IsPrincipalInvestigator],
					[Excluded])     
				select	GI.GrantID,
						CAST(GR.SAPID AS INT),
						GR.SAPID, 
						GR.IsPrincipalInvestigator,
						0
				FROM	[ProfilesStaging].dbo.Grant_Recipients GR
				inner 
				join	[Profile.Data].[Grant.Information] GI on GR.PRN=GI.PRJID
				inner 
				join	[Profile.Data].[Person] P on RIGHT('00000000'+ISNULL(P.internalusername,''),8)=GR.SAPID
				where
				not 
				exists	(select * 
						From	[Profile.Data].[Grant.AffiliatedPeople] GA
						where	GA.GrantID=GI.GrantID and GA.SAPID=GR.SAPID)
				order by GR.SAPID;
		    END;
		    
		    -- Remove duplicate values of grant affiliations
		    with a as
		    (select ROW_NUMBER() over (PARTITION by GrantId, PersonId, SapID, IsPrincipalInvestigator order by excluded desc) as rownum, *
		    from [Profile.Data].[Grant.AffiliatedPeople]) delete From a where rownum > 1;
		  END;
			update A
			set A.StartDate=B.Start_Date 
			From [Profile.Data].[Grant.Information] A
			inner join (select GMIN.PRN, GMIN.Start_Date, GMAX.Stop_Date From 
			(select PRN, MIN(Start_Date) Start_Date from [ProfilesStaging].dbo.Grant_Recipients group by PRN) GMIN
			inner join 
			(select PRN, MAX(Stop_Date) Stop_Date from [ProfilesStaging].dbo.Grant_Recipients group by PRN) GMAX on GMIN.PRN=GMAX.PRN) B on A.PRJID=B.PRN
			where A.StartDate > B.Start_Date;  

			update A
			set A.EndDate=B.Stop_Date 
			From [Profile.Data].[Grant.Information] A
			inner join (select GMIN.PRN, GMIN.Start_Date, GMAX.Stop_Date From 
			(select PRN, MIN(Start_Date) Start_Date from [ProfilesStaging].dbo.Grant_Recipients group by PRN) GMIN
			inner join 
			(select PRN, MAX(Stop_Date) Stop_Date from [ProfilesStaging].dbo.Grant_Recipients group by PRN) GMAX on GMIN.PRN=GMAX.PRN) B on A.PRJID=B.PRN
			where A.EndDate < B.Stop_Date;  

			update	[Profile.Data].[Grant.Information]
			set	GrantTitle =	GrantTitle +
				(CASE WHEN StartDate is NULL THEN '' WHEN StartDate > '2099-12-31' THEN '' ELSE ' - Start Date: ' + CONVERT(varchar(10), StartDate,126) END) + 
				(CASE WHEN EndDate is NULL THEN '' WHEN EndDate > '2099-12-31 00:00:00.000' THEN '' ELSE ' - End Date: ' + CONVERT(varchar(10), EndDate,126) END);
          COMMIT; 
        EXEC  [Profile.Data].[Grant.Entity.UpdateEntityAllPersons];
        END TRY
        BEGIN CATCH
			--Check success
            IF @@TRANCOUNT > 0 
                ROLLBACK

			-- Raise an error with the details of the exception
            SELECT  @ErrMsg = ERROR_MESSAGE() ,
                    @ErrSeverity = ERROR_SEVERITY()

            RAISERROR(@ErrMsg, @ErrSeverity, 1)
        END CATCH	            
    END;







GO

