USE [ProfilesRNS]
GO
/****** Object:  StoredProcedure [Profile.Data].[Grant.Entity.UpdateEntityAllPersons]    Script Date: 02/10/2014 14:45:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Grant.Entity.UpdateEntityAllPersons]
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;  
  DECLARE @PersonID INT;
  declare cur CURSOR LOCAL for
    select PersonID FROM [ProfilesRNS].[User.Account].[User] WHERE PersonID IS NOT NULL
    
  open cur

  fetch next from cur into @PersonID
  
  while @@FETCH_STATUS = 0 BEGIN
    --execute your sproc on each row
    exec [Profile.Data].[Grant.Entity.UpdateEntityOnePerson] @PersonID
    print @PersonID    
    fetch next from cur into @PersonID
  END

close cur
deallocate cur
  
END
