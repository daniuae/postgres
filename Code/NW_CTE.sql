SELECT c.CustomerName, SUM(p.Price * o.Quantity) AS TotalRevenue
FROM Orders o
-- Join to get customer and products table
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
WHERE YEAR(o.OrderDate) = 2024
GROUP BY c.CustomerName
HAVING SUM(p.Price * o.Quantity) > 1000;


/*
CTE Complete Guide
*/

/*Explaination and definition
CTEs are commonly used when working with multiple subqueries. 
They are created with the distinctive "WITH" keyword and
they can be used in 
	SELECT, 
	INSERT, 
	UPDATE, and 
	DELETE statements. 
	
*/

/*How to create a CTE?
	
	WITH cte_name (column1, column2, ...)
	AS (
	    -- Query that defines the CTE
	    SELECT ...
	    FROM ...
	    WHERE ...
	)
	-- Main query
	SELECT ...
	FROM cte_name;

*/


/*Key Components of CTE

** WITH: Initiates the CTE definition, indicating that the following name represents a temporary result set.

** cte_name: The name is assigned to the CTE to reference it in the main query.

** Optional column list (column1, column2, ...): Specifies column names for the CTE’s result set. 
	This is useful when column names need to be adjusted.

** Query that defines the CTE: The inner query that selects data and shapes the temporary result set.

** Main query: References the CTE by its name, using it like a table.

*/


/*Write a CTE - Step By Step Approach */


/* Step 1 */

SELECT EmployeeID, FirstName, LastName, Salary
FROM Employees
WHERE Salary > 50000;


/*Step 2 */ -- Wrap the query using the " WITH " keyword to create a CTE

WITH EmployeeHighEarn AS (
    SELECT EmployeeID, FirstName, LastName, Salary
    FROM Employees
    WHERE Salary > 50000
)


/*Step 3 */ -- Use the CTE in the Main query

-- Define a Common Table Expression (CTE)
WITH EmployeeHighEarn AS (
    SELECT EmployeeID, FirstName, LastName, Salary
    FROM Employees
    WHERE Salary > 50000
)

-- Use the CTE to select high-earning employees
SELECT EmployeeID, FirstName, LastName
FROM EmployeeHighEarn;


/*Complex Query*/

-- Select customer names and total revenue from their orders
SELECT c.CustomerName, SUM(p.Price * o.Quantity) AS TotalRevenue
FROM Orders o
-- Join to get customer and products table
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID
WHERE YEAR(o.OrderDate) = 2024
GROUP BY c.CustomerName
HAVING SUM(p.Price * o.Quantity) > 1000;


/*Seperation of logic */
-- Define the CTE o.Order_ID, c.contact_name, p.unit_price, p.quantity_per_unit , o.order_date
--order_id, customer_id
select * from public.customers 
select * from public.orders
select * from public.products

WITH OrderDetails AS (
	select cu.customer_id ,os.Order_ID, cu.contact_name, os.order_date
	
		FROM public.customers  cu 
		join public.orders os ON cu.customer_id = os.customer_id
		join public.products pr ON os.product_id = pr.product_id
)
select * from OrderDetails
/*
WITH OrderDetails AS (
    SELECT o.order_id
    FROM public.orders o
    JOIN public.customers c ON o.customer_id   = c.customer_id  
    JOIN public.products p ON o.product_id = p.product_id
    WHERE YEAR(o.OrderDate) = 2024
)
--Main query
SELECT CustomerName, SUM(Price * Quantity) AS TotalRevenue
FROM OrderDetails
GROUP BY CustomerName
HAVING SUM(Price * Quantity) > 1000;
*/

/* Code resusablity */
-- Define a CTE to calculate total and average sales for each category
-- SELECT * FROM public.orders
WITH CategorySales AS (
    SELECT *
    FROM public.Products
    GROUP BY Category
)
-- Select category, total sales, and average sales from the CTE
SELECT Category, TotalSales, AverageSales
FROM CategorySales
WHERE TotalSales > 5000;
/*
	Query Organization and Readability: CTEs improve SQL code readability by dividing queries into logical, 
	sequential steps. Each step in the query process can be represented by its own CTE, making the entire query 
	easier to follow.
	
	Hierarchical Data Traversal: CTEs can help navigate hierarchical relationships, such as organizational 
	structures, parent-child relationships, or any data model that involves nested levels. Recursive CTEs are 
	useful for querying hierarchical data because they allow you to traverse levels iteratively.

	Multi-Level Aggregations: CTEs can help perform aggregations at multiple levels, such as calculating sales 
	figures at different granularities (e.g., by month, quarter, and year). Using CTEs to separate these 
	aggregation steps ensures that each level is calculated independently and logically.

	Combining Data from Multiple Tables: Multiple CTEs can be used to combine data from different tables, 
	making the final combination step more structured. This approach simplifies complex joins and ensures 
	the source data is organized logically for improved readability.

*/

/*Step 1*/
--DROP TABLE IF EXISTS Sales;

CREATE TABLE Sales (
    SaleID SERIAL PRIMARY KEY,
    ProductID INT NOT NULL,
    SalesAmount NUMERIC(10, 2) NOT NULL,
    SaleDate DATE DEFAULT CURRENT_DATE
);
/*Step 2*/

INSERT INTO Sales (ProductID, SalesAmount, SaleDate) VALUES
-- Product 101 sales
(101, 1200.00, '2025-07-01'),
(101, 1800.00, '2025-07-02'),

-- Product 102 sales
(102, 500.00, '2025-07-01'),
(102, 700.00, '2025-07-03'),

-- Product 103 sales
(103, 2200.00, '2025-07-02'),
(103, 2800.00, '2025-07-03'),

-- Product 104 sales
(104, 1500.00, '2025-07-01'),

-- Product 105 sales
(105, 3000.00, '2025-07-02'),
(105, 3200.00, '2025-07-04'),

-- Product 106 sales
(106, 250.00, '2025-07-01');


/**/
/**/

WITH ProductSales AS (
    -- Step 1: Calculate total sales for each product
    SELECT ProductID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
),
AverageSales AS (
    -- Step 2: Calculate the average total sales across all products
    SELECT AVG(TotalSales) AS AverageTotalSales
    FROM ProductSales
)

,
HighSalesProducts AS (
    -- Step 3: Filter products with above-average total sales
    SELECT ProductID, TotalSales
    FROM ProductSales
    WHERE TotalSales > (SELECT AverageTotalSales FROM AverageSales)
)

-- Step 4: Rank the high-sales products
SELECT ProductID, TotalSales, RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
FROM HighSalesProducts;


/**/
/**/
-- Define a CTE to find employees hired more than 5 years ago
WITH LongTermEmployees AS (
    SELECT EmployeeID
    FROM Employees
    WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 5
)
-- Update salaries by 10% for long-term employees identified in the CTE
UPDATE Employees
SET EmployeeSalary = EmployeeSalary * 1.1
WHERE EmployeeID IN (SELECT EmployeeID FROM LongTermEmployees);
