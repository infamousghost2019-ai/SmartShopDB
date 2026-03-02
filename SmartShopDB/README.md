# SmartShopDB

This repository contains the database artefacts for the SmartShop Ltd.  
It is used for the CIS5004 **Practical Database Design and Implementation for SmartShop Ltd.** assessment.

## Structure

- `SQL/` – relational database scripts  
  - `SmartShopDB_Setup.sql` – schema creation & sample data  
  - `MonthlySales.sql`, `TopSellingProducts.sql` – report queries  
  - `TrasactionsTest.sql` – transaction/concurrency example  
  - `SQL_BI_Demo.sql` – combined analytical queries  

- `NoSQL/` – non‑relational examples  
  - `NoSQlSetup.js` – MongoDB shell script to create collections & sample documents  
  - `NoSQL_BI_Demo.js` – BI‑style aggregation queries in MongoDB  

## Usage

1. Run the SQL scripts against a SQL Server instance to create and populate the relational schema.
2. Execute the MongoDB shell scripts (`mongosh --file …`) to build the NoSQL dataset.
3. Refer to the comments in each file for further details and sample queries.

## Report guidance

The assessment report should reference this code, include screenshots of the outputs, and provide explanatory notes covering ER design, normalization, transactions, concurrency, BI visualisations and big‑data/NoSQL comparisons.

## Notes

- The ER diagram is available as Mermaid code within the report.
- Ensure you link to this repository and provide instructions in the submission PDF.
