USE [ProfilesRNS]
GO
/****** Object:  StoredProcedure [User.Account].[Proxy.AddDefaultProxy]    Script Date: 10/01/2013 13:20:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Import].[InsertPersonAffiliationData]
	@Email VARCHAR(200),
	@Title VARCHAR(500),
	@InstitutionName VARCHAR(500),
	@InstitutionAbbreviation VARCHAR(50),
	@DepartmentName VARCHAR(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET nocount  ON;
	
	--TODO: I cannot use the email for the internalusername

	INSERT INTO [Profile.Import].[PersonAffiliation] (internalusername, title, emailaddr, primaryaffiliation, affiliationorder, institutionname, institutionabbreviation, departmentname, departmentvisible, divisionname, facultyrank, facultyrankorder)
		SELECT @Email, @Title, NULL, 1, 1, @InstitutionName, @InstitutionAbbreviation, @DepartmentName, 1, NULL, NULL, NULL
END
