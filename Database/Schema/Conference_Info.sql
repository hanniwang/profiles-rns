USE [ProfilesRNS]
GO

/****** Object:  UserDefinedFunction [dbo].[Conference_Info]    Script Date: 05/20/2014 11:16:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Conference_Info] (@conf_field varchar(max))
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @confname AS VARCHAR(MAX)='';
		
	begin
		set @confname =	(case 
							when 	lower(ltrim(rtrim(@conf_field))) like 'university%' then null
							when (	lower(ltrim(rtrim(@conf_field))) like '%proceedings%' OR
									lower(ltrim(rtrim(@conf_field))) like '%congress%' OR
									lower(ltrim(rtrim(@conf_field))) like '%analysis%' OR
									lower(ltrim(rtrim(@conf_field))) like '%american%' OR
									lower(ltrim(rtrim(@conf_field))) like '%institute%' OR
									lower(ltrim(rtrim(@conf_field))) like '%proc%' OR
									lower(ltrim(rtrim(@conf_field))) like '%association%' OR
									lower(ltrim(rtrim(@conf_field))) like '%statistical%' OR
									lower(ltrim(rtrim(@conf_field))) like '%publication%' OR
									lower(ltrim(rtrim(@conf_field))) like '%neuro%' OR
									lower(ltrim(rtrim(@conf_field))) like '%press%' OR
									lower(ltrim(rtrim(@conf_field))) like '%forum%' OR
									lower(ltrim(rtrim(@conf_field))) like '%symposium%' OR
									lower(ltrim(rtrim(@conf_field))) like '%synposium%' OR
									lower(ltrim(rtrim(@conf_field))) like '%experiment%' OR
									lower(ltrim(rtrim(@conf_field))) like '%biology%' OR
									lower(ltrim(rtrim(@conf_field))) like '%medicine%' OR
									lower(ltrim(rtrim(@conf_field))) like '%surgeon%' OR
									lower(ltrim(rtrim(@conf_field))) like '%orthopaedic%' OR
									lower(ltrim(rtrim(@conf_field))) like '%scientific%' OR
									lower(ltrim(rtrim(@conf_field))) like '%audio%' OR
									lower(ltrim(rtrim(@conf_field))) like '%ed.%' OR
									lower(ltrim(rtrim(@conf_field))) like '%exhibit%' OR
									lower(ltrim(rtrim(@conf_field))) like '%review%' OR
									lower(ltrim(rtrim(@conf_field))) like '%course%' OR
									lower(ltrim(rtrim(@conf_field))) like '%annual%' OR
									lower(ltrim(rtrim(@conf_field))) like '%amia%' OR
									lower(ltrim(rtrim(@conf_field))) like '%meeting%' OR
									lower(ltrim(rtrim(@conf_field))) like '%workshop%' OR
									lower(ltrim(rtrim(@conf_field))) like '%conference%' OR
									lower(ltrim(rtrim(@conf_field))) like 'http%' OR
									lower(ltrim(rtrim(@conf_field))) = 'istu' OR
									lower(ltrim(rtrim(@conf_field))) = 'aapm' OR
									lower(ltrim(rtrim(@conf_field))) like '%international%') then @conf_field
							else 
								null
						end)
	end;						
	RETURN (select @confname)
END;


GO
