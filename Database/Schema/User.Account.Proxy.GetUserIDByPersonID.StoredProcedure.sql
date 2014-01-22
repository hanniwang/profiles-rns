USE [ProfilesRNS]
GO
/****** Object:  StoredProcedure [User.Account].[Proxy.GetUserIDByPersonID]    Script Date: 01/21/2014 15:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [User.Account].[Proxy.GetUserIDByPersonID]
  @PersonID VARCHAR(300)
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET nocount  ON;
  
  -- Add the designated proxy
  SELECT UserID
  FROM [User.Account].[User]
  WHERE PersonID = @PersonID

END


