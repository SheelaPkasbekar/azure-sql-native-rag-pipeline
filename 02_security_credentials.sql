- Create Database Scoped Credential for Azure OpenAI API
  
CREATE DATABASE SCOPED CREDENTIAL AzureOpenAIHeaders
WITH IDENTITY = 'HTTPEndpointHeaders',
SECRET = N'{"api-key":"<YOUR_AZURE_OPENAI_API_KEY>"}';
GO
