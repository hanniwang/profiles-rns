USE [ProfilesStaging]
GO

/****** Object:  UserDefinedFunction [Profile.Data].[get_prf_cat]    Script Date: 04/29/2014 09:15:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  function [Profile.Data].[get_prf_cat] (@tri_cat as varchar(100))
returns varchar(100)
as
begin 
declare 
	@prf_cat as varchar(100); 
	
	select  @prf_cat = [prf_cat] 
	FROM [ProfilesStaging].[dbo].[publication_category]
	where [tri_cat]=@tri_cat;
	
	IF (@prf_cat IS NULL)
	DECLARE @Error AS INT = dbo.fThrowError('No key found for the component "' + @tri_cat + '"');
	RETURN (select @prf_cat)
END

GO