USE [ProfilesRNS]
GO
/****** Object:  StoredProcedure [User.Account].[Proxy.AddDefaultProxy]    Script Date: 10/01/2013 13:20:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Import].[InsertPersonData]
	@FirstName VARCHAR(50),
	@MiddleName VARCHAR(50),
	@LastName VARCHAR(50),
	@Gender CHAR(50),
	@AddressLineOne VARCHAR(55),
	@AddressLIneTwo VARCHAR(55),
	@City VARCHAR(100),
	@State CHAR(2),
	@Zip VARCHAR(10),
	@PhoneNumber VARCHAR(35),
	@Email VARCHAR(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET nocount  ON;
	

	-- TODO: I Cannot use email for the internalusername because of the maxlength restriction for the internalusername

	INSERT INTO [Profile.Import].[Person] (internalusername, firstname, middlename, lastname, displayname, suffix, addressline1, addressline2, addressline3, addressline4, addressstring, City, State, Zip, building, room, floor, latitude, longitude, phone, fax, emailaddr, isactive, isvisible)
		SELECT @Email, @FirstName, @MiddleName, @LastName, @FirstName + ' ' + @MiddleName + ' ' + @LastName, @Gender, @AddressLineOne, @AddressLineTwo, NULL, NULL, @AddressLineTwo, @City, @State, @Zip, NULL, NULL, NULL, NULL, NULL, @PhoneNumber, NULL, @Email, 1, 1
	
END
