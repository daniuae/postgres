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
select * from public.customers 
select * from public.orders
select * from public.products

WITH OrderDetails AS (
	select customer_id FROM public.customers  cu 
	
		
		join orders os on cu.customer_id = os.customer_id
		public.products pr
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


