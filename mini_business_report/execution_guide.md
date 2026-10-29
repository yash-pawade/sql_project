# 🚀 Project Execution & Research Setup Guide

This guide walks you through setting up the **Grocery Retail Sales Analytics** database on your local machine, importing data from CSV files, running queries, and using the dataset for business research or analysis.

## 📋 Prerequisites

Before starting, ensure you have the following installed:

* **MySQL Server** (version 8.0 or higher recommended)
* **MySQL Workbench** (or any SQL client like DBeaver, TablePlus, or VS Code SQL tools)
* **Git** installed on your terminal/command line

---

## 🛠️ Step-by-Step Setup Guide

### Step 1: Clone the Repository

Open your terminal or command prompt and clone the public repository:

```bash
git clone https://github.com/yash-pawade/sql_project.git
cd sql_project/mini_business_report
```

---

### Step 2: Initialize Database and Schema in MySQL Workbench

1. Launch **MySQL Workbench** and connect to your local MySQL Server instance.
2. Open a new SQL tab and create the database schema:

```sql
CREATE DATABASE IF NOT EXISTS sales_dataset;
USE sales_dataset;
```

3. Run the schema creation script (`schema.sql` or table creation script) from the repository to create the existing tables:
   * `customers`
   * `products`
   * `store`
   * `sales`

---

### Step 3: Import CSV Data into Existing Tables

The raw dataset CSV files are located in the `resources/` folder:
* `resources/customers.csv`
* `resources/products.csv`
* `resources/store.csv`
* `resources/sales.csv`

#### How to Import via MySQL Workbench Table Data Import Wizard:

To avoid foreign key conflicts during import, load tables in this exact order: **`customers`** $\rightarrow$ **`products`** $\rightarrow$ **`store`** $\rightarrow$ **`sales`**.

1. In the **Schemas** panel on the left sidebar, expand `sales_dataset` $\rightarrow$ **Tables**.
2. Right-click on the target table (e.g., `customers`) and select **Table Data Import Wizard**.
3. Click **Browse** and select the corresponding CSV file (e.g., `resources/customers.csv`). Click **Next**.
4. Choose **"Use existing table"** and select `sales_dataset.customers`. Click **Next**.
5. Verify column mappings (ensure CSV column names match table column names correctly). Click **Next**.
6. Click **Next** to run the import process.
7. Repeat steps 2–6 for `products.csv`, `store.csv`, and `sales.csv`.

---

### Step 4: Verify Data Import

Run the following query in MySQL Workbench to confirm all rows were successfully imported:

```sql
USE sales_dataset;

SELECT 'customers' AS Table_Name, COUNT(*) AS Row_Count FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'store', COUNT(*) FROM store
UNION ALL
SELECT 'sales', COUNT(*) FROM sales;
```

---

### Step 5: Executing Analytical Queries

You can now run any of the core analysis queries provided in this repository.

#### Example 1: Run Month-over-Month (MoM) Growth

```sql
USE sales_dataset;

WITH MonthlySales AS (
    SELECT 
        DATE_FORMAT(Order_Date, '%Y-%m') AS Sales_Month,
        SUM(Revenue) AS Current_Month_Revenue
    FROM sales
    GROUP BY Sales_Month
),
SalesWithLag AS (
    SELECT 
        Sales_Month,
        Current_Month_Revenue,
        LAG(Current_Month_Revenue) OVER (ORDER BY Sales_Month ASC) AS Previous_Month_Revenue
    FROM MonthlySales
)
SELECT 
    Sales_Month,
    Current_Month_Revenue,
    COALESCE(Previous_Month_Revenue, 0) AS Previous_Month_Revenue,
    ROUND(Current_Month_Revenue - COALESCE(Previous_Month_Revenue, 0), 2) AS Absolute_Growth,
    ROUND(
        ((Current_Month_Revenue - Previous_Month_Revenue) / NULLIF(Previous_Month_Revenue, 0)) * 100, 
        2
    ) AS MoM_Growth_Percentage
FROM SalesWithLag;
```

#### Example 2: Run Top Customer Attrition Rate

```sql
USE sales_dataset;

WITH CustomerLifetimeValue AS (
    SELECT 
        Customer_ID,
        SUM(Revenue) AS Total_Spent,
        MAX(Order_Date) AS Last_Order_Date
    FROM sales
    GROUP BY Customer_ID
),
TopCustomers AS (
    SELECT 
        Customer_ID,
        Total_Spent,
        Last_Order_Date,
        DATEDIFF((SELECT MAX(Order_Date) FROM sales), Last_Order_Date) AS Days_Since_Last_Order
    FROM CustomerLifetimeValue
    WHERE Total_Spent >= (SELECT AVG(Total_Spent) FROM CustomerLifetimeValue)
),
CustomerStatus AS (
    SELECT 
        Customer_ID,
        Total_Spent,
        Last_Order_Date,
        Days_Since_Last_Order,
        CASE 
            WHEN Days_Since_Last_Order > 90 THEN 'Churned'
            ELSE 'Active'
        END AS Status
    FROM TopCustomers
)
SELECT 
    COUNT(Customer_ID) AS Total_Top_Customers,
    COUNT(CASE WHEN Status = 'Churned' THEN 1 END) AS Churned_Top_Customers,
    COUNT(CASE WHEN Status = 'Active' THEN 1 END) AS Active_Top_Customers,
    ROUND(
        (COUNT(CASE WHEN Status = 'Churned' THEN 1 END) * 100.0) / COUNT(Customer_ID), 
        2
    ) AS Top_Customer_Attrition_Rate_Percent
FROM CustomerStatus;
```

---

## 🔬 Using This Project for Research & Analysis

This dataset and query suite can be used for various data research projects:

1. **Exporting Query Results to CSV for Python/R:**
   * In MySQL Workbench, click **Export** on any query results grid to save as `.csv`.
   * Load into Python (`pandas`) or R for statistical analysis, regression models, or machine learning forecasts.

2. **Power BI / Tableau Dashboard Integration:**
   * Connect Power BI or Tableau directly to your local MySQL database (`sales_dataset`).
   * Build interactive visual dashboards for revenue, regional performance, and customer retention metrics.

3. **Custom Business Modeling:**
   * Modify thresholds (e.g., change churn period from 90 days to 60 days or adjust discount percentage limits) to observe changes in business outcomes.