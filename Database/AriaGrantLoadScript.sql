USE [ProfilesRNS]

-- Insert into Grant.Information
INSERT INTO [Profile.Data].[Grant.Information] (
  [ARIAGrantID],
  [ARIARecordID],
  [StartDate],
  [EndDate],
  [GrantTitle],
  [GrantAmount],
  [IsActive]
)
SELECT [ARIAGrant].ARIAGrantID, [ARIAGrant].ARIARecordID, [ARIAGrant].StartDate, [ARIAGrant].StopDate, [ARIAGrant].Title, [ARIAGrant].TotalAmount, 1
FROM [DevDataRepo].[dbo].[ARIAGrant]
WHERE ProjectStatus = 'Awarded';

GO



-- Insert into Grant.AffiliatedPeople
INSERT INTO [Profile.Data].[Grant.AffiliatedPeople] (
  [GrantID],
  [PersonID],
  [SAPID],
  [IsPrincipalInvestigator]
)
SELECT (SELECT [Profile.Data].[Grant.Information].GrantID FROM [Profile.Data].[Grant.Information] WHERE [Grant.Information].ARIARecordID = [AriaGrantRole].ARIARecordID),  (SELECT [User].PersonID FROM [ProfilesRNS].[User.Account].[User] WHERE [User].InternalUserName =  CAST(CAST([AriaGrantRole].SAPID AS INT) AS VARCHAR(10))) , [AriaGrantRole].SAPID, (SELECT CASE WHEN Role='Principal Investigator' THEN 1 ELSE 0 END)
FROM [DevDataRepo].[dbo].[AriaGrantRole]
WHERE SAPID <> 'Non-UAMS'
GO
