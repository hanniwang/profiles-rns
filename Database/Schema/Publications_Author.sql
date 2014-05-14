USE [ProfilesRNS]
GO

/****** Object:  UserDefinedFunction [dbo].[Publications_Author]    Script Date: 05/14/2014 15:08:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Publications_Author] (@id_bibliography int)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @authorlist AS VARCHAR(MAX)='',
			@Bibliographyid AS bigint, 
			@NonUAMSAuthor AS VARCHAR(100)='', 
			@SortOrder AS int;
	DECLARE @count bigint=(select count(*) from [HOSP_SQL1].[FacFac].[dbo].[vTRI_BibliographyAuthors] where BiblioGraphyId=@id_bibliography);
	DECLARE PubCursor cursor for select Bibliographyid,UPPER(SUBSTRING(LTRIM(RTRIM(NonUAMSAuthor)),1,1))+SUBSTRING(LTRIM(RTRIM(NonUAMSAuthor)),2,LEN(LTRIM(RTRIM(NonUAMSAuthor)))),SortOrder from [HOSP_SQL1].[FacFac].[dbo].[vTRI_BibliographyAuthors] where BiblioGraphyId=@id_bibliography order by Bibliographyid,Sortorder;
	
	open PubCursor;
	while @count>0
	begin
		fetch PubCursor into @Bibliographyid, @NonUAMSAuthor, @SortOrder;
			set @authorlist=(case 
								when @authorlist='' THEN ISNULL(@NonUAMSAuthor,'') 
								else 
									case 
										when @NonUAMSAuthor is null then @authorlist
										else @authorlist + ', ' + ISNULL(@NonUAMSAuthor,'') 
									end
							end);
			set @count=@count-1;	
	end;
	close PubCursor;
	deallocate PubCursor; 
	RETURN (select @authorlist)
END;
	

GO