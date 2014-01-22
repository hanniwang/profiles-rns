USE [ProfilesRNS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Grant.InsertPersonAffiliationByGrantID]
  @GrantID INT,
  @PersonID INT,
  @IsPrincipalInvestigator bit
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET nocount  ON;
  
  INSERT INTO [Profile.Data].[Grant.AffiliatedPeople] (GrantID, PersonID, IsPrincipalInvestigator)
    SELECT @GrantID, @PersonID, @IsPrincipalInvestigator
    
END
