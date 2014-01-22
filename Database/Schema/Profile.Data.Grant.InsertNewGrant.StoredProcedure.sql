USE [ProfilesRNS]
GO
/****** Object:  StoredProcedure [Profile.Data].[Grant.InsertNewGrant]    Script Date: 01/21/2014 19:26:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Grant.InsertNewGrant]
  @Title VARCHAR(500),
  -- @StartDate VARCHAR(500),
  -- @EndDate VARCHAR(500),
  @Amount VARCHAR(500),
  @return_value INT OUTPUT
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET nocount  ON;
  
  INSERT INTO [Profile.Data].[Grant.Information] (GrantTitle, StartDate, EndDate, GrantAmount, IsActive)
    SELECT @Title, NULL, NULL, CONVERT(numeric(18,0),@Amount), 1

  SELECT @return_value = SCOPE_IDENTITY()

  SELECT @return_value as id

  RETURN 

END
