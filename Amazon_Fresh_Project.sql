CREATE DATABASE amazon_fresh;
USE amazon_fresh;

SELECT p.ProductName, SUM(od.Quantity) AS total_sold
FROM products p
JOIN order_details od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY total_sold DESC
LIMIT 5;

SELECT c.Name, COUNT(o.OrderID) AS total_orders
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Name
ORDER BY total_orders DESC
LIMIT 5;
SELECT * FROM customers LIMIT 1;

SELECT MONTH(o.OrderDate) AS month_number, 
       MONTHNAME(o.OrderDate) AS month_name,
       SUM(od.Quantity * p.PricePerUnit) AS monthly_sales
FROM orders o
JOIN order_details od ON o.OrderID = od.OrderID
JOIN products p ON od.ProductID = p.ProductID
WHERE YEAR(o.OrderDate) = 2023
GROUP BY MONTH(o.OrderDate), MONTHNAME(o.OrderDate)
ORDER BY month_number;

SELECT ProductName, Category, StockQuantity
FROM products
WHERE StockQuantity < 50
ORDER BY StockQuantity ASC
LIMIT 10;

select distinct City from amazon_fresh.customers;
select distinct Category from amazon_fresh.products;
select * from amazon_fresh.customers 
where City = 'Patelberg';
select * from amazon_fresh.products 
where Category = 'Beauty';

alter table amazon_fresh.customers add CustomerRating int;
alter table amazon_fresh.products modify PricePerUnit decimal(10,2);
alter table amazon_fresh.products drop column SupplierID;

desc amazon_fresh.customers;
desc amazon_fresh.products;

update amazon_fresh.products set StockQuantity = 150 where ProductID = 1;
SET SQL_SAFE_UPDATES = 0;
update amazon_fresh.products set StockQuantity = 150 where ProductID = 1;
SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;
delete from amazon_fresh.suppliers where City = 'Patelberg';
SET SQL_SAFE_UPDATES = 1;
select City from amazon_fresh.suppliers limit 1;

alter table amazon_fresh.reviews add constraint chk_rating check (Rating between 1 and 5);
alter table amazon_fresh.customers alter PrimeMember set default 'No';
alter table amazon_fresh.reviews drop constraint chk_rating;
desc amazon_fresh.customers;

select * from amazon_fresh.customers limit 5; 
select * from amazon_fresh.products limit 5;
select CustomerID, count(*) as TotalOrders from amazon_fresh.orders group by CustomerID limit 5;

select o.OrderID, c.Name, o.OrderDate 
from amazon_fresh.orders o 
inner join amazon_fresh.customers c on o.CustomerID = c.CustomerID 
limit 5;
 
select c.CustomerID, c.Name, o.OrderID 
from amazon_fresh.customers c 
left join amazon_fresh.orders o on c.CustomerID = o.CustomerID 
limit 5;

select p.ProductName, s.SupplierName, p.Price 
from amazon_fresh.products p 
inner join amazon_fresh.suppliers s on p.SupplierID = s.SupplierID 
limit 5;

create view amazon_fresh.customer_orders_view as
select c.CustomerID, c.Name, o.OrderID, o.OrderDate
from amazon_fresh.customers c
inner join amazon_fresh.orders o on c.CustomerID = o.CustomerID;

select * from amazon_fresh.customer_orders_view limit 5;

select CustomerID, Name 
from amazon_fresh.customers 
where CustomerID in (
    select CustomerID from amazon_fresh.orders
) 
limit 5;

select CustomerID as ID, Name as PersonName, 'Customer' as Type 
from amazon_fresh.customers 
union all
select SupplierID as ID, SupplierName as PersonName, 'Supplier' as Type 
from amazon_fresh.suppliers;

select p.Category, count(od.ProductID) as Total_Orders
from amazon_fresh.products p
join amazon_fresh.order_details od on p.ProductID = od.ProductID
group by p.Category
order by Total_Orders desc
limit 3;