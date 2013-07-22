SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Person.Photo](
	[PhotoID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[Photo] [varbinary](max) NULL,
	[PhotoLink] [nvarchar](max) NULL,
 CONSTRAINT [PK_photo] PRIMARY KEY CLUSTERED 
(
	[PhotoID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idx_PersonID] ON [Profile.Data].[Person.Photo] 
(
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
ALTER TABLE [Profile.Data].[Person.Photo]  WITH CHECK ADD  CONSTRAINT [FK_photo_person] FOREIGN KEY([PersonID])
REFERENCES [Profile.Data].[Person] ([PersonID])
GO
ALTER TABLE [Profile.Data].[Person.Photo] CHECK CONSTRAINT [FK_photo_person]
GO
