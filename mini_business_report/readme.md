# 🛒 Grocery Retail Sales Database & Advanced Analytics

![MySQL](https://img.shields.io/badge/MySQL-8.0+-blue?style=for-the-badge&logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/Language-SQL-orange?style=for-the-badge&logo=SQL&logoColor=white)
![Data Analytics](https://img.shields.io/badge/Focus-Business%20Intelligence-green?style=for-the-badge)

An end-to-end MySQL database architecture and business intelligence project designed for a modern grocery retail chain. This project transitions raw transaction data into strategic corporate intelligence, covering schema design, financial validation, and multi-tier analytics using real-world SQL techniques.

---

## 🎯 What I Built & Accomplished

- **Production-Ready Relational Schema:** Designed and optimized a normalized database schema (`sales_dataset`) with proper foreign keys, precision data types (`DECIMAL` for currency), and robust `CHECK` constraints.
- **Enterprise-Grade Data Integrity:** Enforced operational rules for price validation, order quantities, and calculated metrics (`Revenue = Gross_Sales - Discount_Amount`).
- **30-Question BI Business Report:** Structured a 6-tier analytical framework covering basic operational retrieval up to advanced window functions.
- **Advanced SQL Problem-Solving:** Implemented complex queries using **CTEs, Subqueries, Multi-Way Joins, Aggregation, and Window Functions** (`ROW_NUMBER`, `DENSE_RANK`, `LAG`, `DATEDIFF`).

---

## 📊 Key Business Insights Uncovered

Through deep relational querying, this analytics pipeline extracts critical metrics across four enterprise dimensions:

### 1. 👥 Customer Intelligence & Behavioral Metrics
- **Top Customer Lifetime Value (CLV):** Identified top-spending customer segments across different cities and membership tiers.
- **Customer Attrition / Churn Rate:** Built a dynamic attrition model using `DATEDIFF` to track high-value customers who haven't purchased in over 90 days.
- **Demographic Penetration:** Uncovered purchasing patterns across age groups and membership types to guide target marketing.

### 2. 🛍️ Product & Category Profitability
- **Category Profit Margins:** Identified high-revenue merchandise vs. low-margin products across departments (e.g., Dairy, Bakery, Beverages).
- **Price Benchmarking:** Isolated products priced above corporate averages using correlated subqueries and found stagnant/unsold inventory.
- **Discount Elasticity:** Evaluated how promotional discounts (>15%) impacted net overall profitability.

### 3. 🏪 Store Performance & Operations
- **Store Hierarchy:** Ranked operating branches and store formats (Supermarkets vs. Convenience Stores) by net revenue and transaction sizes.
- **Geographic Demand:** Mapped top-selling items back to store locations to identify key regional product drivers.
- **Sequential Sales Tracking:** Indexed daily transactions per store using `ROW_NUMBER()` and computed running daily revenue run-rates.

### 4. 📈 Financial & Growth Metrics
- **Month-over-Month (MoM) Growth:** Tracked sequential monthly revenue velocity and calculated percentage growth using `LAG()` window functions.
- **Payment Method Channels:** Analyzed consumer payment preferences (Cash, Card, Digital) to help optimize POS hardware configurations and processing fees.

---

## 🛠️ Tech Stack & SQL Concepts Applied

| Domain | Techniques / Functions Used |
| :--- | :--- |
| **Database Design** | `CREATE TABLE`, `FOREIGN KEY`, `CHECK`, `INDEX`, `DECIMAL(12,2)` |
| **Basic Data Operations** | `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`, `HAVING`, `BETWEEN` |
| **Relational Joins** | `INNER JOIN`, `LEFT JOIN`, `USING()` |
| **Subqueries** | Scalar Subqueries, Correlated Subqueries, `NOT IN`, `NOT EXISTS` |
| **Modular Logic (CTEs)** | `WITH` clauses for multi-step data pipelines |
| **Window Functions** | `ROW_NUMBER()`, `DENSE_RANK()`, `LAG()`, `SUM() OVER()` |
| **Date & Math Logic** | `DATEDIFF()`, `DATE_FORMAT()`, `COALESCE()`, `ROUND()` |

---

## 📁 Database Schema Quick Reference

```
  +---------------+        +------------------+        +---------------+
  |   CUSTOMERS   |        |      SALES       |        |   PRODUCTS    |
  +---------------+        +------------------+        +---------------+
  | Customer_ID   |<-------| Order_ID         |------->| Product_ID    |
  | Customer_Name |        | Order_Date       |        | Product_Name  |
  | City          |        | Customer_ID (FK) |        | Category      |
  | Age_Group     |        | Product_ID (FK)  |        | Unit_Price    |
  | Member_Type   |        | Store_ID (FK)    |        | Unit_Cost     |
  +---------------+        | Quantity         |        +---------------+
                           | Discount_Percent |
  +---------------+        | Gross_Sales      |
  |     STORE     |        | Discount_Amount  |
  +---------------+        | Revenue          |
  | Store_ID      |<-------| Profit           |
  | Store_Name    |        | Payment_Method   |
  | City          |        +------------------+
  | Store_Type    |
  +---------------+
```

---

## 🚀 How to Run

1. Clone or copy the SQL schema script.
2. Open your MySQL client (e.g., **MySQL Workbench**, **DBeaver**, or **Terminal**).
3. Execute the schema initialization script:
   ```sql
   USE sales_dataset;
   ```
4. Run any of the analytical queries provided in the analytical framework report to extract business metrics.

---

⭐ *Built as part of a Retail Business Intelligence Portfolio.*