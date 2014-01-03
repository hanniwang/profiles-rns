USE [ProfilesRNS]
GO
/****** Object:  StoredProcedure [Profile.Data].[Grant.Entity.UpdateEntityOnePerson]    Script Date: 12/16/2013 15:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Grant.Entity.UpdateEntityOnePerson]
  @PersonID INT
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;

  CREATE TABLE #sql (
    i INT IDENTITY(0,1) PRIMARY KEY,
    s NVARCHAR(MAX)
  )
  INSERT INTO #sql (s)
    SELECT  'EXEC [RDF.Stage].ProcessDataMap '
          +'  @DataMapID = '+CAST(DataMapID AS VARCHAR(50))
          +', @InternalIdIn = '+InternalIdIn
          +', @TurnOffIndexing=0, @SaveLog=0; '
    FROM (
      SELECT *, '''SELECT CAST(GI.GrantID AS VARCHAR(50)) FROM [Profile.Data].[Grant.Information] as GI
        INNER JOIN [Profile.Data].[Grant.AffiliatedPeople] as GA
        ON GI.GrantID = GA.GrantID
        WHERE PersonID = '+CAST(@PersonID AS VARCHAR(50))+'''' InternalIdIn
        FROM [Ontology.].DataMap
        WHERE class = 'http://vivoweb.org/ontology/core#Grant'
          AND NetworkProperty IS NULL
          AND Property IS NULL
      UNION ALL
      SELECT *, '' + CAST(@PersonID AS VARCHAR(50)) + '' InternalIdIn
        FROM [Ontology.].DataMap
        WHERE class = 'http://xmlns.com/foaf/0.1/Person' 
          AND property = 'http://vivoweb.org/ontology/core#hasPrincipalInvestigatorRole'
          AND NetworkProperty IS NULL
      UNION ALL
      SELECT *, '' + CAST(@PersonID AS VARCHAR(50)) + '' InternalIdIn
        FROM [Ontology.].DataMap
        WHERE class = 'http://xmlns.com/foaf/0.1/Person' 
          AND property = 'http://vivoweb.org/ontology/core#hasResearcherRole'
          AND NetworkProperty IS NULL          
      UNION ALL
      SELECT *, '' + CAST(@PersonID AS VARCHAR(50)) +  '' InternalIdIn
        FROM [Ontology.].DataMap
        WHERE class = 'http://vivoweb.org/ontology/core#ResearcherRole' 
          AND property IS NULL
          AND NetworkProperty IS NULL
      UNION ALL
      SELECT *, '' + CAST(@PersonID AS VARCHAR(50)) +  '' InternalIdIn
        FROM [Ontology.].DataMap
        WHERE class = 'http://vivoweb.org/ontology/core#PrincipalInvestigatorRole' 
          AND property IS NULL
          AND NetworkProperty IS NULL
      UNION ALL
      SELECT *, '' + CAST(@PersonID AS VARCHAR(50)) +  '' InternalIdIn
        FROM [Ontology.].DataMap
        WHERE class = 'http://vivoweb.org/ontology/core#PrincipalInvestigatorRole' 
          AND property  = 'http://vivoweb.org/ontology/core#roleContributesTo'
          AND NetworkProperty IS NULL
      UNION ALL
      SELECT *, '' + CAST(@PersonID AS VARCHAR(50)) +  '' InternalIdIn 
        FROM [Ontology.].DataMap
        WHERE class = 'http://vivoweb.org/ontology/core#ResearcherRole' 
          AND property  = 'http://vivoweb.org/ontology/core#roleContributesTo'
          AND NetworkProperty IS NULL

      UNION ALL
      SELECT *, '''SELECT CAST(GI.GrantID AS VARCHAR(50))  InternalIdIn FROM [Profile.Data].[Grant.Information] as GI
        INNER JOIN [Profile.Data].[Grant.AffiliatedPeople] as GA
        ON GI.GrantID = GA.GrantID
        WHERE PersonID = '+CAST(@PersonID AS VARCHAR(50))+''''
        FROM [Ontology.].DataMap
        WHERE class = 'http://vivoweb.org/ontology/core#Grant'
          AND property  = 'http://www.w3.org/2000/01/rdf-schema#label'
          AND NetworkProperty IS NULL
    UNION ALL
       SELECT *, '''SELECT CAST(GI.GrantID AS VARCHAR(50))  InternalIdIn FROM [Profile.Data].[Grant.Information] as GI
        INNER JOIN [Profile.Data].[Grant.AffiliatedPeople] as GA
        ON GI.GrantID = GA.GrantID
        WHERE PersonID = '+CAST(@PersonID AS VARCHAR(50))+''''
        FROM [Ontology.].DataMap
        WHERE class = 'http://vivoweb.org/ontology/core#Grant'
          AND property  = 'http://vivoweb.org/ontology/core#grantDirectCosts'
          AND NetworkProperty IS NULL
    ) t
    ORDER BY DataMapID

  DECLARE @s NVARCHAR(MAX)
  WHILE EXISTS (SELECT * FROM #sql)
  BEGIN
    SELECT @s = s
      FROM #sql
      WHERE i = (SELECT MIN(i) FROM #sql)
    print @s
    EXEC sp_executesql @s
    DELETE
      FROM #sql
      WHERE i = (SELECT MIN(i) FROM #sql)
  END

END
