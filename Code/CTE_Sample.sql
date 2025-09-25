-- Define a CTE to find employees hired more than 5 years ago
WITH LongTermEmployees AS (
    SELECT SALARY,ID,hire_date,CURRENT_DATE,(CURRENT_DATE - Hire_Date) as DATE_DIFFERECE
    FROM Employees  
    --WHERE --DATEDIFF(YEAR, HireDate, GETDATE()) > 5
	-- Difference in hours
  	WHERE CURRENT_DATE - Hire_Date < 1000
)
-- Update salaries by 10% for long-term employees identified in the CTE
UPDATE Employees
SET Salary = Salary * 1.1
WHERE ID IN (SELECT ID FROM LongTermEmployees);


-- Define a CTE to identify products not sold in the last 2 years
WITH OldProducts AS (
    SELECT ProductID
    FROM Products
    -- Use DATEADD to find products with a LastSoldDate more than 2 years ago
    WHERE LastSoldDate < DATEADD(YEAR, -2, GETDATE())
)
-- Delete products identified as old from the main table
DELETE FROM Products
WHERE ProductID IN (SELECT ProductID FROM OldProducts);



SELECT * FROM employees ORDER BY id LIMIT 10 OFFSET 5;


SELECT name, department,
       FIRST_VALUE(name) OVER (PARTITION BY department ORDER BY hire_date) AS first_hired
FROM employees;


select name, department,
	ntile(4) over (order by hire_date) as buckets
FROM employees;





