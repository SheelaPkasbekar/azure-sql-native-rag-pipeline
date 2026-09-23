--1. Create Knowledge Base Table with Native Vector(1536) Column 
CREATE Table dbo.knowledgebase (
  docid int identity (1,1) primary key,
  title nvarchar(200) not null,
  content nvarchar (MAX) not null,
  category nvarchar (50) not null,
  Docvector Vector (1536) Null, 
  createdate datetime2 default sysutcdatetime()
  );
GO

--2. Create a Diskann Vector index for fast cosine similarity
CREATE Vector Index idx_doc_vector
on dbo.knowledgebase (Docvector)
With (Metric = 'Cosine' , Type ='Diskann');
Go

---3. Populate Sample Enterprise Records
Insert into dbo.knowledgebase (title, content, category)
Values
('VPN Troubleshooting', 'If VPN connection drops, restart the Azure Network Adapter and flush DNS using ipconfig /flushdns.', 'IT Support'),
('Password Reset Policy', 'Passwords must be at least 16 characters long and changed every 90 days via Microsoft Entra ID.', 'Security'),
('Laptop Refresh Schedule', 'Hardware refreshes occur every 3 years. Submit a ticket to IT Asset Management with manager approval.', 'IT Support');
GO
