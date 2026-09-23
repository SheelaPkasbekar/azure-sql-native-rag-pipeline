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
