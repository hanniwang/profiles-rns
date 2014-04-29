USE [ProfilesStaging]
GO

/****** Object:  StoredProcedure [Profile.Data].[Load_Non_Tri]    Script Date: 04/29/2014 08:46:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [Profile.Data].[Load_Non_Tri]
AS 
    BEGIN
        SET NOCOUNT ON;	


	-- Start Transaction. Log load failures, roll back transaction on error.
        BEGIN TRY	 
          BEGIN TRAN
            DECLARE @ErrMsg NVARCHAR(4000) ,
                @ErrSeverity INT
        
        -- Delete from NON_TRI_LIST that now have appointments in FacFacts
        delete A
        From [ProfilesStaging].[dbo].[non_tri_list] A
        inner join [HOSP_SQL1].[FacFac].[dbo].[vTRI_Appointments] B on A.ZTXTSAPID=B.SAPID; 
        
        -- Delete from NON_TRI_LIST_AFFILIATIONS that now have appointments in FacFacts
        delete A
        From [ProfilesStaging].[dbo].[non_tri_list_affiliations] A
        inner join [HOSP_SQL1].[FacFac].[dbo].[vTRI_Appointments] B on RIGHT('00000000'+ISNULL(A.internalusername,''),8)=B.SAPID; 
        
        -- Insert into NON_TRI_LIST profiles that no longer
        -- have appointments within TRI
        -- Doing it for SAPData
		insert into [ProfilesStaging].[dbo].[non_tri_list]
		select	C.ZTXTLNAME, 
			C.ZTXTFNAME, 
			'No Longer showing in TRI_Appointments -SAP- ' + CAST(CONVERT(VARCHAR(19), GETDATE(), 120) as varchar),
			C.* 
		From [ProfilesStaging].[Profile.Import].Person A
		right outer join [ProfilesRNS].[Profile.Import].[Person] B on A.internalusername=B.internalusername 
		inner join [DevDataRepo].[dbo].[ZHRSEC] C on C.ZTXTSAPID=RIGHT('00000000'+ISNULL(B.internalusername,''),8)
		where A.internalusername is null and B.internalusername is not null
		and not exists (select * from [ProfilesStaging].[dbo].[non_tri_list] Z
		where C.ZTXTSAPID = Z.ZTXTSAPID)
            -- Doing it for SAPData
            
            -- Doing it for TRI SAPData
		insert into [ProfilesStaging].[dbo].[non_tri_list]
			(MANDT,
			last_name, 
			first_name,
			comments,
			ZTXTSAPID,
			ZTXTLNAME,
			ZTXTFNAME,
			ZTXTMNAME,
			ZTXTWORKLOCATION,
			ZTXTBUILDING,
			ZTXTMAILSLOT,
			ZTXTEMAILADDRESS,
			ZTXTPHONE1, 
			ZTXTPOSDESCRIPT,
			ZTXTDEPTNUMBER,ZTXTSUBDEPTNUM,ZTXTTITLE,ZTXTPERSONCLASS,ZDTEHIREDATE,ZDTEDELETEDDATE,ZDTECREATED ) 
	    	select	'200',C.lastname, 
			C.firstname, 
			'No Longer showing in TRI_Appointments -TRI SAP- ' + CAST(CONVERT(VARCHAR(19), GETDATE(), 120) as varchar), -- comments
			RIGHT('00000000'+ISNULL(B.internalusername,''),8), -- SAPID, 
			C.lastname, 
			C.firstname,
			C.middlename, 
			C.room,
			C.building,
			C.slot, 
			C.EmailAddress,
			C.Workphone, 
			C.title,
			'','','','','','',''
	    	From [Profile.Import].Person A
	    	right outer join [ProfilesRNS].[Profile.Import].[Person] B on A.internalusername=B.internalusername
	    	inner join (select	SAPID,
	    		LastName,
	    		FirstName,
	    		MiddleName,
	    		Gender,
	    		EmailAddress,
	    		Workphone,
	    		Department,
	    		Slot,
	    		Room,
	    		Building,
	    		faxnum,
	    		title,
	    		Room + (CASE WHEN LTRIM(RTRIM(ISNULL(Room,''))) ='' THEN '' ELSE ' ' END) + LTRIM(RTRIM(Building)) Address1,
	    		(Address1) Address2,
	    		City,
	    		State,
	    		Zip
	    		FROM [HOSP_SQL1].[FacFac].[dbo].[vTRI_SAPFaculty]) C on C.SAPID=RIGHT('00000000'+ISNULL(B.internalusername,''),8)
	    	where A.internalusername is null and B.internalusername is not null
	    	and not exists (select * from [ProfilesStaging].[dbo].[non_tri_list] Z
		where C.SAPID = Z.ZTXTSAPID);

        -- Insert into NON_TRI_LIST_AFFILIATIONS profiles that no longer
        -- have appointments within TRI
 		insert into [ProfilesStaging].[dbo].[non_tri_list_affiliations]
		select	A.last_name, 
				A.first_name, 
				A.comments, 
				B.* 
		From	non_tri_list A
		inner 
		join	[ProfilesRNS].[Profile.Import].PersonAffiliation B on A.ZTXTSAPID=RIGHT('00000000'+ISNULL(B.internalusername,''),8)
		where	A.comments like 'No Longer%'
		and 
		not 
		exists	(select * from [ProfilesStaging].[dbo].[non_tri_list_affiliations] Z
				where B.internalusername=Z.internalusername);

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

