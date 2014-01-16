USE [ProfilesRNS]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[GetPersonIDByProfileID]
  @ProfileID VARCHAR(300)
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET nocount  ON;
  
  SELECT I.InternalID
    FROM (Select * FROM [ProfilesRNS].[RDF.].[Node] 
    WHERE Value = 'http://192.168.104.102/profiles/profile/'+ @ProfileID) t
    Inner join [ProfilesRNS].[RDF.Stage].[InternalNodeMap] as I on t.InternalNodeMapID = I.InternalNodeMapID;
 
  
END
