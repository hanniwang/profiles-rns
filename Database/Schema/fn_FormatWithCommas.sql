USE [ProfilesStaging]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_FormatWithCommas]    Script Date: 05/14/2014 13:45:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_FormatWithCommas] 
(
    -- Add the parameters for the function here
    @value varchar(50)
)
RETURNS varchar(50)
AS
BEGIN
    -- Declare the return variable here
    DECLARE @WholeNumber varchar(50) = NULL, @Decimal varchar(10) = '', @CharIndex int = charindex('.', @value)

    IF (@CharIndex > 0)
        SELECT @WholeNumber = SUBSTRING(@value, 1, @CharIndex-1), @Decimal = SUBSTRING(@value, @CharIndex, LEN(@value))
    ELSE
        SET @WholeNumber = @value

    IF(LEN(@WholeNumber) > 3)
        SET @WholeNumber = dbo.fn_FormatWithCommas(SUBSTRING(@WholeNumber, 1, LEN(@WholeNumber)-3)) + ',' + RIGHT(@WholeNumber, 3)



    -- Return the result of the function
    RETURN @WholeNumber + @Decimal

END
GO
