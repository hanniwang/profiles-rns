-- This file contains all of the ontology..datamap triple mappings that were needed to integrate grant information into profiles

-- ResearcherRole internal node definition
INSERT INTO [ProfilesRNS].[Ontology.].[DataMap] (
  [DataMapID],
  [DataMapGroup],
  [IsAutoFeed],
  [Graph],
  [Class],
  [NetworkProperty],
  [Property],
  [MapTable],
  [sInternalType],
  [sInternalID],
  [cClass],
  [cInternalType],
  [cInternalID],
  [oClass],
  [oInternalType],
  [oInternalID],
  [oValue],
  [oDataType],
  [oLanguage],
  [oStartDate],
  [oStartDatePrecision],
  [oEndDate],
  [oEndDatePrecision],
  [oObjectType],
  [Weight],
  [OrderBy],
  [ViewSecurityGroup],
  [EditSecurityGroup],
  [_ClassNode],
  [_NetworkPropertyNode],
  [_PropertyNode]
)
VALUES
(
  (SELECT max([DataMapID]) + 1 FROM [ProfilesRNS].[Ontology.].[DataMap]),
  1,
  1,
  1337,
  'http://vivoweb.org/ontology/core#ResearcherRole'
  NULL,
  NULL,
  '[Profile.Data].[Grant.AffiliatedPeople]',
  'Researcher',
  'PersonID',
  NULL,
  NULL,
  NULL,
  NULL, 
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  0,
  1,
  NULL,
  -1,
  -40,
  1484,
  NULL,
  NULL
)
GO

-- Grant internal node defintion

INSERT INTO [ProfilesRNS].[Ontology.].[DataMap] (
  [DataMapID],
  [DataMapGroup],
  [IsAutoFeed],
  [Graph],
  [Class],
  [NetworkProperty],
  [Property],
  [MapTable],
  [sInternalType],
  [sInternalID],
  [cClass],
  [cInternalType],
  [cInternalID],
  [oClass],
  [oInternalType],
  [oInternalID],
  [oValue],
  [oDataType],
  [oLanguage],
  [oStartDate],
  [oStartDatePrecision],
  [oEndDate],
  [oEndDatePrecision],
  [oObjectType],
  [Weight],
  [OrderBy],
  [ViewSecurityGroup],
  [EditSecurityGroup],
  [_ClassNode],
  [_NetworkPropertyNode],
  [_PropertyNode]
)
VALUES
(
  (SELECT max([DataMapID]) + 1 FROM [ProfilesRNS].[Ontology.].[DataMap]),
  1,
  1,
  1337,
  'http://vivoweb.org/ontology/core#Grant',
  NULL,
  NULL,
  '[Profile.Data].[Grant.Information]',
  'Grant',
  'GrantID',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  0,
  1,
  NULL,
  -1,
  -40,
  28,
  NULL,
  NULL
)
GO

-- <Researcher role instance> http://vivoweb.org/ontology/core#roleContributesTo <Grant instance> mapping

INSERT INTO [ProfilesRNS].[Ontology.].[DataMap] (
  [DataMapID],
  [DataMapGroup],
  [IsAutoFeed],
  [Graph],
  [Class],
  [NetworkProperty],
  [Property],
  [MapTable],
  [sInternalType],
  [sInternalID],
  [cClass],
  [cInternalType],
  [cInternalID],
  [oClass],
  [oInternalType],
  [oInternalID],
  [oValue],
  [oDataType],
  [oLanguage],
  [oStartDate],
  [oStartDatePrecision],
  [oEndDate],
  [oEndDatePrecision],
  [oObjectType],
  [Weight],
  [OrderBy],
  [ViewSecurityGroup],
  [EditSecurityGroup],
  [_ClassNode],
  [_NetworkPropertyNode],
  [_PropertyNode]
)
VALUES
(
  (SELECT max([DataMapID]) + 1 FROM [ProfilesRNS].[Ontology.].[DataMap]),
  1,
  1,
  1338,
  'http://vivoweb.org/ontology/core#ResearcherRole',
  NULL,
  'http://vivoweb.org/ontology/core#roleContributesTo',
  '(SELECT *  FROM [ProfilesRNS].[Profile.Data].[Grant.AffiliatedPeople] where IsPrincipalInvestigator = 0) t',
  'Researcher',
  'PersonID',
  NULL,
  NULL,
  NULL,
  'http://vivoweb.org/ontology/core#Grant',
  'Grant',
  'GrantID',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  0,
  1,
  NULL,
  -1,
  -40,
  1484,
  NULL,
  1182
)
GO


-- http://xmlns.com/foaf/0.1/Person http://vivoweb.org/ontology/core#hasResearcherRole <researcherRole instance> mapping
INSERT INTO [ProfilesRNS].[Ontology.].[DataMap] (
  [DataMapID],
  [DataMapGroup],
  [IsAutoFeed],
  [Graph],
  [Class],
  [NetworkProperty],
  [Property],
  [MapTable],
  [sInternalType],
  [sInternalID],
  [cClass],
  [cInternalType],
  [cInternalID],
  [oClass],
  [oInternalType],
  [oInternalID],
  [oValue],
  [oDataType],
  [oLanguage],
  [oStartDate],
  [oStartDatePrecision],
  [oEndDate],
  [oEndDatePrecision],
  [oObjectType],
  [Weight],
  [OrderBy],
  [ViewSecurityGroup],
  [EditSecurityGroup],
  [_ClassNode],
  [_NetworkPropertyNode],
  [_PropertyNode]
)
VALUES
(
  (SELECT max([DataMapID]) + 1 FROM [ProfilesRNS].[Ontology.].[DataMap]),
  1,
  1,
  1339,
  'http://xmlns.com/foaf/0.1/Person,'
  NULL,
  'http://vivoweb.org/ontology/core#hasResearcherRole,'
  '(SELECT *  FROM [ProfilesRNS].[Profile.Data].[Grant.AffiliatedPeople] where IsPrincipalInvestigator = 0) t,'
  'Person',
  'PersonID',
  NULL,
  NULL,
  NULL,
  'http://vivoweb.org/ontology/core#ResearcherRole,'
  'Researcher',
  'PersonID',
  NULL,
  NULL ,
  NULL,
  NULL,
  NULL ,
  NULL,
  NULL,
  0,
  1,
  NULL,
  -1 ,
  -40,
  48 ,
  NULL ,
  1445
)
GO


-- <Grant instance> http://www.w3.org/2000/01/rdf-schema#label 'grant name' mapping
INSERT INTO [ProfilesRNS].[Ontology.].[DataMap] (
  [DataMapID],
  [DataMapGroup],
  [IsAutoFeed],
  [Graph],
  [Class],
  [NetworkProperty],
  [Property],
  [MapTable],
  [sInternalType],
  [sInternalID],
  [cClass],
  [cInternalType],
  [cInternalID],
  [oClass],
  [oInternalType],
  [oInternalID],
  [oValue],
  [oDataType],
  [oLanguage],
  [oStartDate],
  [oStartDatePrecision],
  [oEndDate],
  [oEndDatePrecision],
  [oObjectType],
  [Weight],
  [OrderBy],
  [ViewSecurityGroup],
  [EditSecurityGroup],
  [_ClassNode],
  [_NetworkPropertyNode],
  [_PropertyNode]
)
VALUES
(
  (SELECT max([DataMapID]) + 1 FROM [ProfilesRNS].[Ontology.].[DataMap]),
  1,
  1,
  1340,
  'http://vivoweb.org/ontology/core#Grant',
  NULL,
  'http://www.w3.org/2000/01/rdf-schema#label',
  '[Profile.Data].[Grant.Information]',
  'Grant',
  'GrantID',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'GrantTitle',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  1,
  1,
  NULL,
  -1,
  -40,
  28,
  NULL ,
  15
)
GO


-- <Grant instance> http://vivoweb.org/ontology/core#grantDirectCosts 'grant amount' mapping

INSERT INTO [ProfilesRNS].[Ontology.].[DataMap] (
  [DataMapID],
  [DataMapGroup],
  [IsAutoFeed],
  [Graph],
  [Class],
  [NetworkProperty],
  [Property],
  [MapTable],
  [sInternalType],
  [sInternalID],
  [cClass],
  [cInternalType],
  [cInternalID],
  [oClass],
  [oInternalType],
  [oInternalID],
  [oValue],
  [oDataType],
  [oLanguage],
  [oStartDate],
  [oStartDatePrecision],
  [oEndDate],
  [oEndDatePrecision],
  [oObjectType],
  [Weight],
  [OrderBy],
  [ViewSecurityGroup],
  [EditSecurityGroup],
  [_ClassNode],
  [_NetworkPropertyNode],
  [_PropertyNode]
)
VALUES
(
  (SELECT max([DataMapID]) + 1 FROM [ProfilesRNS].[Ontology.].[DataMap]),
  1,
  1,
  1341,
  'http://vivoweb.org/ontology/core#Grant',
  NULL,
  'http://vivoweb.org/ontology/core#grantDirectCosts',
  '[Profile.Data].[Grant.Information]',
  'Grant',
  'GrantID' ,
  NULL ,
  NULL,
  NULL,
  NULL ,
  NULL ,
  NULL ,
  'GrantAmount' ,
  NULL ,
  NULL  ,
  NULL ,
  NULL ,
  NULL ,
  NULL,
  1 ,
  1 ,
  NULL,
  -1,
  -40,
  28 ,
  NULL  ,
  1423
  )
GO



-- http://vivoweb.org/ontology/core#PrincipalInvestigatorRole internal node defintion
INSERT INTO [ProfilesRNS].[Ontology.].[DataMap] (
  [DataMapID],
  [DataMapGroup],
  [IsAutoFeed],
  [Graph],
  [Class],
  [NetworkProperty],
  [Property],
  [MapTable],
  [sInternalType],
  [sInternalID],
  [cClass],
  [cInternalType],
  [cInternalID],
  [oClass],
  [oInternalType],
  [oInternalID],
  [oValue],
  [oDataType],
  [oLanguage],
  [oStartDate],
  [oStartDatePrecision],
  [oEndDate],
  [oEndDatePrecision],
  [oObjectType],
  [Weight],
  [OrderBy],
  [ViewSecurityGroup],
  [EditSecurityGroup],
  [_ClassNode],
  [_NetworkPropertyNode],
  [_PropertyNode]
)
VALUES
(
  (SELECT max([DataMapID]) + 1 FROM [ProfilesRNS].[Ontology.].[DataMap]),
  1,
  1,
  1342,
  'http://vivoweb.org/ontology/core#PrincipalInvestigatorRole' ,
  NULL ,
  NULL ,
  '[Profile.Data].[Grant.AffiliatedPeople]',
  'PrincipalInvestigator',
  'PersonID' ,
  NULL,
  NULL ,
  NULL ,
  NULL ,
  NULL,
  NULL ,
  NULL  ,
  NULL ,
  NULL ,
  NULL  ,
  NULL ,
  NULL ,
  NULL ,
  0,
  1,
  NULL ,
  -1 ,
  -40 ,
  1474 ,
  NULL,
  NULL
)
GO



-- http://xmlns.com/foaf/0.1/Person http://vivoweb.org/ontology/core#hasPrincipalInvestigatorRole <PrincipalInvestigatorRole Instance> mapping
INSERT INTO [ProfilesRNS].[Ontology.].[DataMap] (
  [DataMapID],
  [DataMapGroup],
  [IsAutoFeed],
  [Graph],
  [Class],
  [NetworkProperty],
  [Property],
  [MapTable],
  [sInternalType],
  [sInternalID],
  [cClass],
  [cInternalType],
  [cInternalID],
  [oClass],
  [oInternalType],
  [oInternalID],
  [oValue],
  [oDataType],
  [oLanguage],
  [oStartDate],
  [oStartDatePrecision],
  [oEndDate],
  [oEndDatePrecision],
  [oObjectType],
  [Weight],
  [OrderBy],
  [ViewSecurityGroup],
  [EditSecurityGroup],
  [_ClassNode],
  [_NetworkPropertyNode],
  [_PropertyNode]
)
VALUES
(
  (SELECT max([DataMapID]) + 1 FROM [ProfilesRNS].[Ontology.].[DataMap]),
  1,
  1,
  1343,
  'http://xmlns.com/foaf/0.1/Person',
  NULL,
  'http://vivoweb.org/ontology/core#hasPrincipalInvestigatorRole',
  '(SELECT *  FROM [ProfilesRNS].[Profile.Data].[Grant.AffiliatedPeople] where IsPrincipalInvestigator = 1) t',
  'Person',
  'PersonID',
  NULL,
  NULL,
  NULL,
  'http://vivoweb.org/ontology/core#PrincipalInvestigatorRole',
  'PrincipalInvestigator',
  'PersonID',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL ,
  NULL,
  0,
  1,
  NULL,
  -1 ,
  -40,
  48 ,
  NULL,
  1472
  )
GO


-- http://vivoweb.org/ontology/core#PrincipalInvestigatorRole http://vivoweb.org/ontology/core#roleContributesTo <Grant Instance> mapping


INSERT INTO [ProfilesRNS].[Ontology.].[DataMap] (
  [DataMapID],
  [DataMapGroup],
  [IsAutoFeed],
  [Graph],
  [Class],
  [NetworkProperty],
  [Property],
  [MapTable],
  [sInternalType],
  [sInternalID],
  [cClass],
  [cInternalType],
  [cInternalID],
  [oClass],
  [oInternalType],
  [oInternalID],
  [oValue],
  [oDataType],
  [oLanguage],
  [oStartDate],
  [oStartDatePrecision],
  [oEndDate],
  [oEndDatePrecision],
  [oObjectType],
  [Weight],
  [OrderBy],
  [ViewSecurityGroup],
  [EditSecurityGroup],
  [_ClassNode],
  [_NetworkPropertyNode],
  [_PropertyNode]
)
VALUES
(
  (SELECT max([DataMapID]) + 1 FROM [ProfilesRNS].[Ontology.].[DataMap]),
  1,
  1,
  1344,
  'http://vivoweb.org/ontology/core#PrincipalInvestigatorRole',
  NULL,
  'http://vivoweb.org/ontology/core#roleContributesTo',
  '(SELECT *  FROM [ProfilesRNS].[Profile.Data].[Grant.AffiliatedPeople] where IsPrincipalInvestigator = 1) t ',
  'PrincipalInvestigator',
  'PersonID' ,
  NULL ,
  NULL ,
  NULL ,
  'http://vivoweb.org/ontology/core#Grant',
  'Grant',
  'GrantID',
  NULL,
  NULL,
  NULL ,
  NULL ,
  NULL ,
  NULL,
  NULL,
  0,
  1,
  NULL ,
  -1 ,
  -40,
  1474,
  NULL,
  1182
  )
GO
