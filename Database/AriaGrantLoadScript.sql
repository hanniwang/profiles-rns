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
select A.GrantID,C.PersonId, B.SAPID,
(SELECT CASE WHEN B.Role='Principal Investigator' THEN 1 ELSE 0 END)  from [Profile.Data].[Grant.Information] A
inner join [DevDataRepo].[dbo].[AriaGrantRole] B on A.ARIARECORDID=B.ARIARecordID
inner join [DevDataRepo].[dbo].[ARIAGrant] X on B.ARIARecordID=X.ARIARecordID
inner join [ProfilesRNS].[User.Account].[User] C on B.SAPID=RIGHT('00000000'+ISNULL(C.internalusername,''),8)
where X.ProjectStatus='Awarded'
and B.Role='Principal Investigator' 
and B.SAPID  <> 'Non-UAMS'
GO