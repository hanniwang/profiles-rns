USE [ProfilesRNS]
GO

/****** Object:  UserDefinedFunction [dbo].[Additional_Info]    Script Date: 05/20/2014 11:12:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Additional_Info] (@bibliography_id varchar(max))
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @Bibliographyid AS VARCHAR(MAX)='';
		
	begin
		set @Bibliographyid=(case 
								when ltrim(rtrim(@bibliography_id)) = '' OR @bibliography_id is null then null
								when ltrim(rtrim(@bibliography_id)) like '% %' then substring(@bibliography_id,1,CHARINDEX(' ', @bibliography_id))
								when ltrim(rtrim(@bibliography_id)) like '%-%' then substring(@bibliography_id,1,CHARINDEX('-', @bibliography_id))  
								else @bibliography_id
							end)
	end;						
	RETURN (select @Bibliographyid)
END;

GO

