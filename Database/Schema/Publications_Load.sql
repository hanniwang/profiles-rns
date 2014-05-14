USE [ProfilesRNS]
GO

/****** Object:  StoredProcedure [dbo].[Publications_Load]    Script Date: 05/14/2014 15:17:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Publications_Load]
as 
begin 
	EXEC [ProfilesRNS].[dbo].[Load_Publications_Staging];
	declare @count bigint, 
			@count1 bigint;	
	declare @PersonID INT,
			@HMS_PUB_CATEGORY nvarchar(60),
			@PUB_TITLE nvarchar(2000) = '',
			@ARTICLE_TITLE nvarchar(2000) = '',
			@CONF_EDITORS nvarchar(2000) = '',
			@CONF_LOC nvarchar(2000) = '',
			@EDITION nvarchar(30) = '',
			@PLACE_OF_PUB nvarchar(60) = '',
			@VOL_NUM nvarchar(30) = '',
			@PART_VOL_PUB nvarchar(15) = '',
			@ISSUE_PUB nvarchar(30) = '',
			@PAGINATION_PUB nvarchar(30) = '',
			@ADDITIONAL_INFO nvarchar(2000) = '',
			@PUBLISHER nvarchar(255) = '',
			@CONF_NM nvarchar(2000) = '',
			@CONF_DTS nvarchar(60) = '',
			@REPT_NUMBER nvarchar(35) = '',
			@CONTRACT_NUM nvarchar(35) = '',
			@DISS_UNIV_NM nvarchar(2000) = '',
			@NEWSPAPER_COL nvarchar(15) = '',
			@NEWSPAPER_SECT nvarchar(15) = '',
			@PUBLICATION_DT smalldatetime = '',
			@ABSTRACT varchar(max) = '',
			@AUTHORS varchar(max) = '',
			@URL varchar(1000) = '',
			@created_by varchar(50) = '';
	select @count=(select count(*) from [ProfilesStaging].[dbo].[Load_Publications] A
					INNER JOIN [Profile.Data].Person B on A.PersonID=B.PersonID);
	declare PubCursor cursor for 
			select A.PersonID, HmsPubCategory, PubTitle, ArticleTitle, ConfEditors, ConfLoc, EDITION, PlaceOfPub, VolNum, PartVolPub, IssuePub,PaginationPub, AdditionalInfo, Publisher, ConfNm, ConfDTs, ReptNumber, ContractNum, DissUnivNm, NewspaperCol, NewspaperSect, PublicationDT, Abstract, Authors, URL, CreatedBy
			from [ProfilesStaging].[dbo].[Load_Publications] A
			INNER JOIN [Profile.Data].Person B on A.PersonID=B.PersonID;
	select @count1=(select count(distinct A.PersonID) from [ProfilesStaging].[dbo].[Load_Publications] A
					INNER JOIN [Profile.Data].Person B on A.PersonID=B.PersonID);
	declare PubCursor1 cursor for 
			select distinct A.PersonID
			from [ProfilesStaging].[dbo].[Load_Publications] A
			INNER JOIN [Profile.Data].Person B on A.PersonID=B.PersonID;
	open PubCursor;
	--PRINT @count; 
	while @count>0
	begin
		fetch PubCursor into @PersonID,@HMS_PUB_CATEGORY,@PUB_TITLE,@ARTICLE_TITLE,@CONF_EDITORS,@CONF_LOC,@EDITION,@PLACE_OF_PUB,@VOL_NUM,@PART_VOL_PUB,@ISSUE_PUB,@PAGINATION_PUB,@ADDITIONAL_INFO,@PUBLISHER,@CONF_NM,@CONF_DTS,@REPT_NUMBER,@CONTRACT_NUM,@DISS_UNIV_NM,@NEWSPAPER_COL,@NEWSPAPER_SECT,@PUBLICATION_DT,@ABSTRACT,@AUTHORS,@URL,@created_by;
			--PRINT cast(ISNULL(@PersonID,'') as varchar(20)) + ' - ' + ISNULL(@HMS_PUB_CATEGORY,'') + ' - ' + ISNULL(@PUB_TITLE,'') + ' - ' + ISNULL(@ARTICLE_TITLE,'') + ' - ' + ISNULL(@CONF_EDITORS,'') + ' - ' + ISNULL(@CONF_LOC,'') + ' - ' + ISNULL(@EDITION,'') + ' - ' + ISNULL(@PLACE_OF_PUB,'') + ' - ' + ISNULL(@VOL_NUM,'') + ' - ' + ISNULL(@PART_VOL_PUB,'') + ' - ' + ISNULL(@ISSUE_PUB,'') + ' - ' + ISNULL(@PAGINATION_PUB,'') + ' - ' + ISNULL(@ADDITIONAL_INFO,'') + ' - ' + ISNULL(@PUBLISHER,'') + ' - ' + ISNULL(@CONF_NM,'') + ' - ' + ISNULL(@CONF_DTS,'') + ' - ' + ISNULL(@REPT_NUMBER,'') + ' - ' + ISNULL(@CONTRACT_NUM,'') + ' - ' + ISNULL(@DISS_UNIV_NM,'') + ' - ' + ISNULL(@NEWSPAPER_COL,'') + ' - ' + ISNULL(@NEWSPAPER_SECT,'') + ' - ' + CONVERT(varchar(10), ISNULL(@PUBLICATION_DT,''),126) + ' - ' + ISNULL(@ABSTRACT,'') + ' - ' + ISNULL(@AUTHORS,'') + ' - ' + ISNULL(@URL,'') + ' - ' + ISNULL(@created_by,'');
			EXEC	[Profile.Data].[Publication.MyPub.AddPublication]
			@PersonID = @PersonID,
			@HMS_PUB_CATEGORY = @HMS_PUB_CATEGORY,
			@PUB_TITLE=@PUB_TITLE,
			@ARTICLE_TITLE = @ARTICLE_TITLE,
			@CONF_EDITORS = @CONF_EDITORS,
			@CONF_LOC = @CONF_LOC,
			@EDITION = @EDITION,
			@PLACE_OF_PUB=@PLACE_OF_PUB,
			@VOL_NUM = @VOL_NUM,
			@PART_VOL_PUB = @PART_VOL_PUB,
			@ISSUE_PUB = @ISSUE_PUB,
			@PAGINATION_PUB = @PAGINATION_PUB,
			@ADDITIONAL_INFO = @ADDITIONAL_INFO,
			@PUBLISHER = @PUBLISHER,
			@CONF_NM = @CONF_NM,
			@CONF_DTS = @CONF_DTS,
			@REPT_NUMBER = @REPT_NUMBER,
			@CONTRACT_NUM = @CONTRACT_NUM,
			@DISS_UNIV_NM = @DISS_UNIV_NM,
			@NEWSPAPER_COL = @NEWSPAPER_COL,
			@NEWSPAPER_SECT = @NEWSPAPER_SECT,
			@PUBLICATION_DT = @PUBLICATION_DT,
			@ABSTRACT = @ABSTRACT,
			@AUTHORS = @AUTHORS,
			@URL = @URL,
			@created_by = @created_by;
--			EXEC [Profile.Data].[Publication.Entity.UpdateEntityOnePerson] @PersonID;
--			EXEC [Profile.Data].[Publication.Entity.UpdateEntity];
			set @count=@count-1;
	end;
	close PubCursor;
	deallocate PubCursor; 
	open PubCursor1;
	while @count1>0
	begin
		fetch PubCursor1 into @PersonID;
			EXEC [Profile.Data].[Publication.Entity.UpdateEntityOnePerson] @PersonID;
			set @count1=@count1-1;
	end;
	close PubCursor1;
	deallocate PubCursor1; 
	
	begin
		EXEC [Profile.Data].[Publication.Entity.UpdateEntity];
	end;

	--PRINT @count;
end;



GO

