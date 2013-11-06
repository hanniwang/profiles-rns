USE [ProfilesRNS]
GO
/****** Object:  StoredProcedure [User.Account].[Proxy.GetUserIDBySessionID]    Script Date: 11/06/2013 11:25:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[Proxy.GetUserIDBySessionID]
	@SessionID UNIQUEIDENTIFIER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET nocount  ON;
	
	-- Add the designated proxy
	SELECT UserID
	FROM [User.Session].[Session]
	WHERE SessionID = @SessionID

END


