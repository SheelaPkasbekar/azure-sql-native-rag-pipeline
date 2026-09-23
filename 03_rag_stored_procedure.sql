CREATE OR ALTER PROCEDURE dbo.sp_AnswerCustomerQuery
    @UserQuestion NVARCHAR(MAX),
    @QueryVector VECTOR(1536)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Context NVARCHAR(MAX);
    DECLARE @Payload NVARCHAR(MAX);
    DECLARE @Response NVARCHAR(MAX);
    DECLARE @RetVal INT;

    -- 1. Retrieve top 3 relevant context chunks using DiskANN Vector Index
    SELECT @Context = STRING_AGG(CAST(Content AS NVARCHAR(MAX)), CHAR(10) + '---' + CHAR(10))
    FROM (
        SELECT TOP(3) t.Content
        FROM VECTOR_SEARCH(
            TABLE = dbo.KnowledgeBase AS t,
            COLUMN = DocVector,
            SIMILAR_TO = @QueryVector,
            METRIC = 'COSINE',
            TOP_N = 3
        ) AS v
    ) AS ContextChunks;

    -- 2. Construct OpenAI API Request JSON Payload
    WITH ChatMessages AS (
        SELECT 'system' AS [role], 
               'You are an enterprise AI assistant. Ground your answer strictly in this context: ' + ISNULL(@Context, 'No context found.') AS [content]
        UNION ALL
        SELECT 'user' AS [role], @UserQuestion AS [content]
    )
    SELECT @Payload = (
        SELECT 
            (SELECT [role], [content] FROM ChatMessages FOR JSON PATH) AS [messages],
            0.2 AS [temperature],
            500 AS [max_tokens]
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    );

    -- 3. Execute REST call directly to Azure OpenAI Endpoint
    EXEC @RetVal = sp_invoke_external_rest_endpoint
        @url = N'https://<YOUR_RESOURCE>.openai.azure.com/openai/deployments/<YOUR_DEPLOYMENT>/chat/completions?api-version=2024-02-01',
        @headers = N'{"Content-Type":"application/json"}',
        @credential = AzureOpenAIHeaders,
        @timeout = 240,
        @method = N'POST',
        @payload = @Payload,
        @response = @Response OUTPUT;

    -- 4. Parse Scalar LLM Response
    IF @RetVal = 0
    BEGIN
        SELECT JSON_VALUE(@Response, '$.choices.message.content') AS AIResponse;
    END
    ELSE
    BEGIN
        RAISERROR('Azure OpenAI API invocation failed.', 16, 1);
    END
END;
GO
