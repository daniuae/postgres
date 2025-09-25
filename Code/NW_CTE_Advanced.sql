/*****************************Northwind Database /* Working  */ *******************************************************/
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


/* Working  */
 

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
),
HighSalesProducts AS (
    -- Step 3: Filter products with above-average total sales
    SELECT ProductID, TotalSales
    FROM ProductSales
    WHERE TotalSales > (SELECT AverageTotalSales FROM AverageSales)
)
-- Step 4: Rank the high-sales products
SELECT ProductID, TotalSales, RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
FROM HighSalesProducts;


/* Working */

/* SELECT * FROM Employees1 */
	
-- Define a CTE to find employees hired more than 5 years ago
WITH LongTermEmployees AS (
    SELECT Employee_ID,Hire_Date
    FROM Employees1
    --WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 5
	WHERE CURRENT_DATE - Hire_Date > 5
)
-- Update salaries by 10% for long-term employees identified in the CTE
UPDATE Employees1
SET  Salary =  Salary * 1.1
WHERE Employee_ID IN (SELECT Employee_ID FROM LongTermEmployees);

/*Merge*/
CREATE TABLE Inventory (
    ProductID INT PRIMARY KEY,
    Quantity INT
);

CREATE TABLE NewInventoryData (
    ProductID INT PRIMARY KEY,
    Quantity INT
);

-- Existing inventory data
INSERT INTO Inventory (ProductID, Quantity) VALUES
(101, 50),
(102, 15),
(103, 30),
(104, 10);

-- New inventory data (some overlapping ProductIDs, some new)
INSERT INTO NewInventoryData (ProductID, Quantity) VALUES
(102, 20),   -- Updated quantity
(103, 25),   -- Updated quantity
(105, 40),   -- New product
(106, 60);   -- New product

--Approach 1
-- Insert new or update existing product quantities
INSERT INTO Inventory (ProductID, Quantity)
SELECT ProductID, Quantity FROM NewInventoryData
ON CONFLICT (ProductID)
DO UPDATE SET Quantity = EXCLUDED.Quantity;

--Approach 2
WITH MergedInventory AS (
    SELECT ni.ProductID, ni.Quantity AS NewQuantity, i.Quantity AS CurrentQuantity
    FROM NewInventoryData ni
    LEFT JOIN Inventory i ON ni.ProductID = i.ProductID
)
MERGE INTO Inventory AS i
USING MergedInventory AS mi
ON i.ProductID = mi.ProductID
WHEN MATCHED THEN
    UPDATE SET i.Quantity = mi.NewQuantity
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, Quantity) VALUES (mi.ProductID, mi.NewQuantity);

-----------------------------------------------------------
CREATE TABLE Organization (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    ManagerID INT NULL -- Nullable because top managers have no manager
);
INSERT INTO Organization (EmployeeID, FirstName, LastName, Department, ManagerID) VALUES
(1, 'John', 'Smith', 'Executive', NULL),         -- Top-level manager (CEO)
(2, 'Sara', 'Johnson', 'Marketing', 1),
(3, 'Mike', 'Brown', 'Sales', 1),
(4, 'Laura', 'Jones', 'Marketing', 2),
(5, 'James', 'Davis', 'Sales', 3),
(6, 'Emily', 'Wilson', 'HR', 1),
(7, 'Peter', 'Miller', 'HR', 6),
(8, 'Linda', 'Taylor', 'Marketing', 2);

WITH RECURSIVE RecursiveOrgCTE AS
(
    SELECT EmployeeID, FirstName, LastName, Department, ManagerID
    FROM Organization
    WHERE ManagerID IS NULL

    UNION ALL

    SELECT e.EmployeeID, e.FirstName, e.LastName, e.Department, e.ManagerID
    FROM Organization e
    JOIN RecursiveOrgCTE r ON e.ManagerID = r.EmployeeID
)
SELECT *
FROM RecursiveOrgCTE;

/*Table Schema for the below sample*/
CREATE TABLE EmployeesCTE (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES EmployeesCTE(EmployeeID)
);

INSERT INTO EmployeesCTE (EmployeeID, EmployeeName, ManagerID) VALUES
(1, 'Andrew (CEO)', NULL),         -- Top-level manager (no manager)
(2, 'Britto (CTO)', 1),
(3, 'Charlie (CFO)', 1),
(4, 'Daniel (Dev Manager)', 2),
(5, 'Emma (Finance Manager)', 3),
(6, 'Florence (Developer)', 4),
(7, 'Gabrial (Accountant)', 5),
(8, 'Hamara (Intern)', 6);

/*  Working  ******************** */
/* SELECT * from EmployeesCTE */
WITH Recursive EmpHierarchy AS (
    -- Anchor member: select the top-level manager
    SELECT EmployeeID, EmployeeName, ManagerID, 1 AS Level
    FROM EmployeesCTE
    WHERE EmployeeID = 1  -- Starting with the top-level manager
	UNION ALL
    -- Recursive member: find employees who report to the current managers
	SELECT e.EmployeeID, e.EmployeeName, e.ManagerID, eh.Level + 1
    FROM EmployeesCTE e
    INNER JOIN EmpHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT EmployeeID, EmployeeName, Level FROM EmpHierarchy OPTION (MAXRECURSION 10);
--SELECT * FROM EmpHierarchy;
/*-----------------------------------------------------------*/
WITH Recursive RecursiveOrganizationCTE AS
(
	-- anchor member
    SELECT EmployeeID, FirstName, LastName, Department,ManagerID
    FROM Organization
    WHERE ManagerID IS NULL
    UNION ALL
    -- recursive term
    SELECT e.EmployeeID, e.FirstName, e.LastName, e.department,e.ManagerID
    FROM Organization e
    JOIN RecursiveOrganizationCTE r ON e.ManagerID = r.EmployeeID
)
--Show the records stored inside  the CTE we created above
SELECT *
FROM RecursiveOrganizationCTE ;


-----------------------------------------------------------

-- WITH SalesCTE AS (
--     SELECT customer_id, SUM(amount) AS total_sales
--     FROM sales
--     GROUP BY customer_id
-- )
-- SELECT c.customer_name, s.total_sales
-- FROM customers c
-- JOIN SalesCTE s ON c.customer_id = s.customer_id;


