USE [ProfilesRNS]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Grant.GetGrantsForPersonID]
  @PersonID VARCHAR(300),
  @IsPrincipalInvestigator bit
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET nocount  ON;
  

SELECT g.GrantID as ID, g.GrantTitle as Title, g.GrantAmount as Amount, g.StartDate as StartDate, g.EndDate as EndDate
  FROM (
  SELECT GrantID FROM [ProfilesRNS].[Profile.Data].[Grant.AffiliatedPeople]
  WHERE PersonID = @PersonID AND IsPrincipalInvestigator = @IsPrincipalInvestigator) t 
  INNER JOIN [ProfilesRNS].[Profile.Data].[Grant.Information] g on g.GrantID = t.GrantID;
  
END
