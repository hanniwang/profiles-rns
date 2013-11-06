USE [ProfilesRNS]
GO
/****** Object:  StoredProcedure [User.Account].[Proxy.DeleteDefaultProxy]    Script Date: 11/06/2013 11:09:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[Proxy.DeleteDefaultProxy]
	@UserID VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET nocount  ON;
	
	-- Add the designated proxy
	DELETE
		FROM [User.Account].[DefaultProxy]
		WHERE UserID = @UserID

END
