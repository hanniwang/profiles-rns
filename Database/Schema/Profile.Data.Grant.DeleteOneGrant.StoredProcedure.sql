USE [ProfilesRNS]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Grant.DeleteOneGrant]
  @PersonID INT,
  @GrantID varchar(50)
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;
      Update [Profile.Data].[Grant.AffiliatedPeople]
      SET Excluded = 1
      WHERE GrantID = @GrantID AND PersonID = @PersonID
   
END
GO
