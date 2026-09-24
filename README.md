# azure-sql-native-rag-pipeline
Enterprise Native Vector Search &amp; RAG Pipeline in Azure SQL Database (DP-800 Architecture Pattern)
# Enterprise Native Vector Search & RAG Pipeline in Azure SQL

An end-to-end Retrieval-Augmented Generation (RAG) database solution built for **Azure SQL Database** implementing key **Microsoft DP-800** exam design patterns.

## 🏗️ Architecture
1. **Native Vectors:** Stores 1536-dim embeddings in native `VECTOR(1536)` columns.
2. **DiskANN Index:** Uses `CREATE VECTOR INDEX` with Cosine distance for high-speed Approximate Nearest Neighbor (ANN) search.
3. **In-Engine Retrieval:** Uses `VECTOR_SEARCH` to retrieve top context chunks without full table scans.
4. **Direct REST Call:** Uses `sp_invoke_external_rest_endpoint` to communicate with Azure OpenAI directly from T-SQL.
5. **JSON Processing:** Uses `FOR JSON PATH, WITHOUT_ARRAY_WRAPPER` to construct API payloads and `JSON_VALUE` to extract scalar completions.

## 📂 Project Structure
* `sql/01_schema_and_vector_index.sql` - Table schema and DiskANN vector index
* `sql/02_security_credentials.sql` - Database-scoped credentials for API authentication
* `sql/03_rag_stored_procedure.sql` - Complete RAG stored procedure

# Enterprise Native Vector Search & RAG Pipeline in Azure SQL

An end-to-end Retrieval-Augmented Generation (RAG) database architecture built entirely inside **Azure SQL Database**. This project demonstrates how to perform high-speed similarity searches and invoke Azure OpenAI REST endpoints directly within T-SQL—eliminating the need for external vector databases or middle-tier application servers.

---

## 🏗️ Architecture & Data Flow

```text
[ User Query & Search Vector ]
              │
              ▼
  [ dbo.sp_AnswerCustomerQuery ]
              │
              ├── 1. VECTOR_SEARCH (DiskANN Cosine Index) ──► Retrieves Top-3 Relevant Chunks
              │
              ├── 2. FOR JSON PATH ──────────────────────────► Formats Azure OpenAI Request Payload
              │
              ├── 3. sp_invoke_external_rest_endpoint ───────► Executes HTTPS POST to Azure OpenAI
              │
              └── 4. JSON_VALUE ─────────────────────────────► Extracts Scalar Text Completion Answer
📥 Input & Output Specification
Component
Description / Type
Example Value / Payload
Input: Query Vector
VECTOR(1536)
1536-dimensional array from text-embedding-ada-002 or text-embedding-3-small
Input: User Question
NVARCHAR(MAX)
"What is the corporate password reset policy?"
Security Credential
DATABASE SCOPED CREDENTIAL
AzureOpenAIHeaders storing encrypted api-key header
Internal Processing
T-SQL In-Engine RAG
VECTOR_SEARCH ➔ FOR JSON PATH ➔ sp_invoke_external_rest_endpoint
Output: AI Response
NVARCHAR(MAX)
"Passwords must be at least 16 characters long and updated every 90 days."
📂 Repository File Index
azure-sql-native-rag-pipeline/
├── README.md                           <-- Project Overview & Guide
└── sql/
    ├── 01_schema_and_vector_index.sql  <-- Table creation, VECTOR(1536), & DiskANN index
    ├── 02_security_credentials.sql     <-- Database Scoped Credential configuration
    └── 03_rag_stored_procedure.sql     <-- Complete RAG workflow procedure