-- CREATING DATABASE FOR STORING GROCERY SHOP SALES DATA 
create database sales_dataset ;
use sales_dataset ;

-- DEFINING STRUCTURE FOR CUSTOMERS TABLE
create table customers(
Customer_ID varchar(7) primary key,
Customer_Name varchar(60) NOT NULL,
City varchar(30) NOT NULL,
Age_Group varchar(7) NOT NULL,
Member_Type varchar(20) NOT NULL
);

-- DEFINING STRUCTURE FOR PRODUCTS TABLE
create table products(
Product_ID  varchar(7) primary key,
Product_Name varchar(30) NOT NULL,
Category varchar(60) NOT NULL,
Unit_Price int NOT NULL,
Unit_Cost int NOT NULL
);

-- DEFINING STRUCTURE FOR STORE TABLE
create table store(
Store_ID varchar(7) primary key,
Store_Name varchar(60) NOT NULL,
City varchar(30) NOT NULL,
Store_Type varchar(30) NOT NULL
);

-- DEFINING STRUCTURE FOR SALES TABLE
create table sales(
Order_ID varchar(12) primary key,
Order_Date date
,Customer_ID varchar(7) NOT NULL,
Product_ID varchar(7) NOT NULL,
Store_ID  varchar(7) NOT NULL,
Quantity int CHECK (Quantity > 0),
Discount_Percent int,
Gross_Sales int NOT NULL,
Discount_Amount int NOT NULL,
Revenue int NOT NULL,
Profit int NOT NULL,
Payment_Method varchar(30) NOT NULL,
foreign key (Customer_ID) references Customers(Customer_ID),
foreign key (Product_ID) references Products(Product_ID),
foreign key (Store_ID) references Store(Store_ID),
constraint chk_revenue 
check(Revenue = Gross_sales - Discount_Amount)

);


select * from customers ;
select * from products;
select *from sales;
select * from store ;
