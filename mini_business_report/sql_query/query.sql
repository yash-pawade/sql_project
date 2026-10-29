-- 1.Find the names and details of all customers living in 'Mumbai', arranged alphabetically.
select * from customers
where city = "mumbai"
order by Customer_Name;

-- 2.Payment Types: Show a clean list of all payment methods used by customers (like Cash, Credit Card, UPI), sorted alphabetically.
select payment_method from sales
group by Payment_Method
order by Payment_Method;

-- 3.Expensive beverages: List all products in the 'beverages' section that cost more than 70, starting from the highest price.

select * from products 
where category = 'Beverages' and Unit_Price > 70 
order by Unit_Price desc;

-- 4. Top 10 Biggest Orders: Show the 10 orders that brought in the most money, including the order ID, date, and final bill amount.
select order_id , Order_date , revenue as final_bill_amount from sales 
order by revenue desc
limit 10;

-- 5.Bulk Orders by Date: Find orders where a customer bought more than 3 items during a specific time period, sorted from oldest to newest date.
SELECT 
    s.Order_ID,
    s.Order_Date,
    c.Customer_Name,
    p.Product_Name,
    s.Quantity,
    s.Revenue
FROM sales s
JOIN customers c using (customer_id)
JOIN products p using (product_id)
WHERE s.Quantity > 3
  AND s.Order_Date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY s.Order_Date ASC;

-- 6. Sales by Category: Find the total number of items sold, total bill amounts, and final earnings for each product category.

select 
 p.Category,
 sum(s.Quantity) as total_no_of_items,
 sum(s.Revenue) as total_bill_amount,
 sum(s.Profit) as final_earning
from sales s 
JOIN products p using (Product_id)
group by p.Category;

-- 7.Average Costs: Find the average store price and the total stock cost for products in each category.

SELECT 
    p.Category,
    ROUND(AVG(p.Unit_Price), 2) AS Average_Store_Price,
    ROUND(SUM(p.Unit_Cost * s.Quantity), 2) AS Total_Stock_Cost
FROM products p
JOIN sales s using (Product_ID)
GROUP BY p.Category
ORDER BY Total_Stock_Cost DESC;

-- 8.Profitable Store Types: Find total profit made by each type of store but only show store types that made over a certain target profit.

select st.Store_Type, sum(s.profit) AS total_profit from store st 
join sales s using (store_id)
group by st.store_type 
having total_profit > 50000;

-- 9.Popular Payment Methods: Count how many times each payment method was used and the total money collected through each method.
select payment_method, sum(revenue) as total_money_collected ,count(*) as method_used from sales
group by Payment_Method
order by method_used desc ;

-- 10. Busy Customer Cities: List all cities that have more than 50 registered customers, showing the city name and total customer count.
select city , count(*) as total_customers
 from customers 
 group by city 
 having total_customers > 50 ;
 
-- 11. Above-Average Priced Items: Find items that cost more than the average price of all items in the store catalog.
select * from products 
where Unit_Price > (select avg(Unit_Price) from products) ;

-- 12.Identify customers who have placed an order with a revenue amount higher than the average revenue of all orders.
select c.customer_name , sum(s.revenue) as total_spent from sales s 
join customers c using (customer_id)
group by Customer_ID
having total_spent > (select avg(avg_spent) from (select sum(revenue) as avg_spent from sales group by Customer_ID) as avg_spent_table);

-- 13.List products that have never been ordered in any sales transaction using a subquery.
SELECT * 
FROM products
WHERE Product_ID NOT IN (
    SELECT Product_ID 
    FROM sales
);
-- 14.Top Product Cities: Find your best-selling items first, then see which city sold the highest amount of those top items.
WITH TopProducts AS (
    SELECT Product_ID, SUM(Quantity) AS Total_Sold
    FROM sales
    GROUP BY Product_ID
    ORDER BY Total_Sold DESC
    LIMIT 5
),
ProductCitySales AS (
    SELECT 
        p.Product_Name,
        st.City,
        SUM(s.Quantity) AS City_Quantity_Sold,
        ROW_NUMBER() OVER (PARTITION BY p.Product_ID ORDER BY SUM(s.Quantity) DESC) AS city_rank
    FROM sales s
    JOIN store st ON s.Store_ID = st.Store_ID
    JOIN products p ON s.Product_ID = p.Product_ID
    JOIN TopProducts tp ON s.Product_ID = tp.Product_ID
    GROUP BY p.Product_ID, p.Product_Name, st.City
)

SELECT Product_Name, City, City_Quantity_Sold
FROM ProductCitySales
WHERE city_rank = 1;

-- 15.Top Spenders' Favorite Items: Find your highest-spending customers first, then check which item categories they buy from the most.
WITH TopCustomers AS (
    SELECT Customer_ID
    FROM sales
    GROUP BY Customer_ID
    ORDER BY SUM(Revenue) DESC
    LIMIT 10
),
CustomerCategorySpend AS (
    SELECT 
        c.Customer_Name,
        p.Category,
        SUM(s.Quantity) AS Total_Items_Bought,
        ROW_NUMBER() OVER (PARTITION BY c.Customer_ID ORDER BY SUM(s.Quantity) DESC) AS category_rank
    FROM sales s
    JOIN customers c ON s.Customer_ID = c.Customer_ID
    JOIN products p ON s.Product_ID = p.Product_ID
    JOIN TopCustomers tc ON s.Customer_ID = tc.Customer_ID
    GROUP BY c.Customer_ID, c.Customer_Name, p.Category
)
SELECT Customer_Name, Category, Total_Items_Bought
FROM CustomerCategorySpend
WHERE category_rank = 1;

-- 16.Discount Impact on Profit: Find all sales that had big discounts, then calculate how much profit you actually made on those discounted items.
WITH BigDiscountSales AS (
    SELECT 
        Product_ID,
        Discount_Amount,
        Profit
    FROM sales
    WHERE Discount_Percent > 15
)
SELECT 
    p.Category,
    COUNT(b.Product_ID) AS Count_Of_Discounted_Orders,
    SUM(b.Discount_Amount) AS Total_Discounts_Given,
    SUM(b.Profit) AS Total_Profit_Made
FROM BigDiscountSales b
JOIN products p ON b.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Total_Profit_Made DESC;


-- Top Customers Attrition Rate 
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
        DATEDIFF('2026-03-01', Last_Order_Date) AS Days_Since_Last_Order
    FROM CustomerLifetimeValue
    WHERE Total_Spent >= (SELECT AVG(Total_Spent) FROM CustomerLifetimeValue) -- Spending threshold
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


-- Month over Month sales Growth 
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


