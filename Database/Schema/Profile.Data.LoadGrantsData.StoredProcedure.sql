CREATE procedure [Profile.Data].[LoadGrantsData]
AS 
    BEGIN
        SET NOCOUNT ON;	


	-- Start Transaction. Log load failures, roll back transaction on error.
        BEGIN TRY	 
          BEGIN TRAN
            DECLARE @ErrMsg NVARCHAR(4000) ,
                @ErrSeverity INT
                
            -- truncate table
            truncate table [Profile.Data].[Grant.Information]; 
            truncate table [Profile.Data].[Grant.AffiliatedPeople];
            
            INSERT INTO [Profile.Data].[Grant.Information] (
	      [ARIAGrantID],
	      [ARIARecordID],
	      [StartDate],
	      [EndDate],
	      [GrantTitle],
	      [GrantAmount],
	      [IsActive]
	    )
	    SELECT [ARIAGrant].ARIAGrantID, [ARIAGrant].ARIARecordID, [ARIAGrant].StartDate, [ARIAGrant].StopDate, [ARIAGrant].Title, [ARIAGrant].TotalAmount, 1
	    FROM [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] ARIAGrant
	    WHERE ProjectStatus = 'Awarded';
	    
	    INSERT INTO [Profile.Data].[Grant.AffiliatedPeople] (
	      [GrantID],
	      [PersonID],
	      [SAPID],
	      [IsPrincipalInvestigator]
	    )                                              
	    select A.GrantID,C.PersonId, B.SAPID,
	    (SELECT CASE WHEN B.Role='Principal Investigator' THEN 1 ELSE 0 END)  from [Profile.Data].[Grant.Information] A
	    inner join [HOSP_SQL1].[FacFac].[dbo].[vAriaGrantRole] B on A.ARIARECORDID=B.ARIARecordID
	    inner join [HOSP_SQL1].[FacFac].[dbo].[vAriaGrant] X on B.ARIARecordID=X.ARIARecordID
	    inner join [ProfilesRNS].[User.Account].[User] C on B.SAPID=RIGHT('00000000'+ISNULL(C.internalusername,''),8)
	    where X.ProjectStatus='Awarded'
	    and B.SAPID  <> 'Non-UAMS'
	    and C.PersonID IS NOT NULL;

          COMMIT;    
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