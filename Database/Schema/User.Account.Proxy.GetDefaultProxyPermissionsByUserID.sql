USE [ProfilesRNS]
GO
/****** Object:  StoredProcedure [User.Account].[Proxy.GetDefaultProxyPermissionsByUserID]    Script Date: 11/06/2013 11:25:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[Proxy.GetDefaultProxyPermissionsByUserID]
	@UserID VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET nocount  ON;
	
	-- Add the designated proxy
	SELECT (case when IsNull(ProxyForInstitution,'')='' then 'All' else ProxyForInstitution end) Institution,
			(case when IsNull(ProxyForDepartment,'')='' then 'All' else ProxyForDepartment end) Department
	FROM [User.Account].[DefaultProxy]
	WHERE UserID = @UserID

END

