USE [ProfilesRNS]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Narrative.EditNarrativeByPersonID]
  @PersonID VARCHAR(300),
  @TextVal VARCHAR(MAX)
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET nocount  ON;
  
    -- If the row does not exist yet then make the row
    INSERT INTO [Profile.Data].[NarrativeSection] (PersonID, Text)
    SELECT @PersonID, @TextVal
    WHERE NOT EXISTS (
      SELECT Text
      FROM [Profile.Data].[NarrativeSection]
      WHERE PersonID = @PersonID
    );


    -- If the row already exists then update the text value for that row
    UPDATE [Profile.Data].[NarrativeSection]
    SET Text = @TextVal
    WHERE PersonID = @PersonID AND EXISTS (
      SELECT Text
      FROM [Profile.Data].[NarrativeSection]
      WHERE PersonID = @PersonID
    );

END
