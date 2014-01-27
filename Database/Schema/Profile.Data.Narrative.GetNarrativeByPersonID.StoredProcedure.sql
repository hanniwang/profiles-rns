USE [ProfilesRNS]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[GetNarrativeByPersonID]
  @PersonID VARCHAR(300)
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET nocount  ON;

  SELECT Text
  FROM [Profile.Data].[NarrativeSection]
  WHERE PersonID = @PersonID
END
