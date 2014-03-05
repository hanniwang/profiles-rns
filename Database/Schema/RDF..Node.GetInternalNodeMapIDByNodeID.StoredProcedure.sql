USE [ProfilesRNS]
GO
/****** Object:  StoredProcedure [RDF.].[Node.GetInternalNodeMapIDByNodeID]   ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.].[Node.GetInternalNodeMapIDByNodeID]
    @NodeID bigint
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET nocount  ON;

    
    SELECT internaln.InternalID as InternalID
    FROM [RDF.].[Node] n inner join [RDF.Stage].[InternalNodeMap] internaln 
       on (n.InternalNodeMapID=internaln.InternalNodeMapID)
    WHERE n.InternalNodeMapID IS NOT NULL
     AND n.NodeID = @NodeID
    UNION SELECT ' ' as InternalID
    Order By InternalID DESC

   

END


