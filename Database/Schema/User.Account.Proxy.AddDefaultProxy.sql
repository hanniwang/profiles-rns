USE [ProfilesRNS]
GO
/****** Object:  StoredProcedure [User.Account].[Proxy.AddDefaultProxy]    Script Date: 10/01/2013 13:20:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[Proxy.AddDefaultProxy]
	@UserID INT, 
	@ProxyForInstitution VARCHAR(500),
	@ProxyForDepartment VARCHAR(500),
	@IsVisible bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET nocount  ON;
	
	-- Add the designated proxy
	INSERT INTO [User.Account].[DefaultProxy] (UserID, ProxyForInstitution, ProxyForDepartment, IsVisible)
		SELECT @UserID, @ProxyForInstitution, @ProxyForDepartment, @IsVisible
END
