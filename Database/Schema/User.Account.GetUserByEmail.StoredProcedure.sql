USE [ProfilesRNS]
GO
/****** Object:  StoredProcedure [User.Account].[GetUserByEmail]    Script Date: 12/02/2013 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[GetUserByEmail]
    @Email VARCHAR(500)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET nocount  ON;
    
    -- Add the designated proxy
    SELECT UserID
    FROM [User.Account].[User]
    WHERE EmailAddr = LOWER(@Email)

END


