USE [ProfilesRNS]
GO

/****** Object:  StoredProcedure [Profile.Data].[LoadGrantsData]    Script Date: 03/07/2014 02:16:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [Profile.Data].[LoadGrantsData] (@REFRESH BIT=0 )
AS 
    BEGIN
        SET NOCOUNT ON;	

	-- Start Transaction. Log load failures, roll back transaction on error.
        BEGIN TRY	 
          BEGIN TRAN
           
            DECLARE @ErrMsg NVARCHAR(4000) ,
                @ErrSeverity INT
		
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
		    select [ARIAGrant].ARIAGrantID, [ARIAGrant].ARIARecordID, [ARIAGrant].StartDate, [ARIAGrant].StopDate, [ARIAGrant].Title, [ARIAGrant].TotalAmount, [ARIAGrant].PRN, 1 
		    From ( 
		    select ROW_NUMBER() over (partition by PRN order by ARIARecordID desc, StopDate desc) as rownumber, * 
		    from  [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] 
		    where ProjectStatus = 'Awarded') ARIAGrant 
		    where rownumber < 2;

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
		    inner join [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] X on B.ARIARecordID=X.ARIARecordID and A.PRJID=X.PRN
		    inner join [ProfilesRNS].[User.Account].[User] C on B.SAPID=RIGHT('00000000'+ISNULL(C.internalusername,''),8)
		    where X.ProjectStatus='Awarded'
		    and B.SAPID  <> 'Non-UAMS'
		    and C.PersonID IS NOT NULL;

		    -- Remove duplicate values of grant affiliations
		    with a as
		   (select ROW_NUMBER() over (PARTITION by GrantId, PersonId, SapID, IsPrincipalInvestigator order by excluded desc) as rownum, *
		    from [Profile.Data].[Grant.AffiliatedPeople]) delete From a where rownum > 1;
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
		    SELECT [ARIAGrant].ARIAGrantID, [ARIAGrant].ARIARecordID, [ARIAGrant].StartDate, [ARIAGrant].StopDate, [ARIAGrant].Title, [ARIAGrant].TotalAmount, [ARIAGrant].PRN,1
		    FROM [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] ARIAGrant
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
		    SELECT [ARIAGrant].ARIAGrantID, [ARIAGrant].ARIARecordID, [ARIAGrant].StartDate, [ARIAGrant].StopDate, [ARIAGrant].Title, [ARIAGrant].TotalAmount, [ARIAGrant].PRN, 1
		    FROM [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] ARIAGrant
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
		    inner join [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] X on B.ARIARecordID=X.ARIARecordID and A.PRJID=X.PRN
		    inner join [ProfilesRNS].[User.Account].[User] C on B.SAPID=RIGHT('00000000'+ISNULL(C.internalusername,''),8)
		    where X.ProjectStatus='Awarded'
		    and B.SAPID  <> 'Non-UAMS'
		    and C.PersonID IS NOT NULL;
		    
		    -- Remove duplicate values of grant affiliations
		    with a as
		    (select ROW_NUMBER() over (PARTITION by GrantId, PersonId, SapID, IsPrincipalInvestigator order by excluded desc) as rownum, *
		    from [Profile.Data].[Grant.AffiliatedPeople]) delete From a where rownum > 1;
		  END;
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