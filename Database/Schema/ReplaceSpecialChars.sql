USE [ProfilesStaging]
GO

/****** Object:  UserDefinedFunction [dbo].[ReplaceSpecialChars]    Script Date: 05/14/2014 13:44:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[ReplaceSpecialChars](@MyString as varchar(MAX)) returns varchar(MAX) as 
begin
	declare @result as varchar(MAX)
	declare @i as int
	declare @n as int
	set @result = ''
	set @i = 1 
	if @MyString = '' or @MyString is null 
		set @result = '' 
	else
		begin
			set @n = datalength(@MyString)
			while @i <= @n
				begin
					if ascii(substring(@MyString, @i, 1)) between 32 and 127 
						set @result = @result+substring(@MyString, @i, 1)
						set @i = @i + 1;
				end
		end
	return @result
end;


GO