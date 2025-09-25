-- DROP TABLE IF EXISTS Organization;

-- CREATE TABLE Organization (
--     EmployeeID SERIAL PRIMARY KEY,
--     FirstName VARCHAR(50),
--     LastName VARCHAR(50),
--     Department VARCHAR(50),
--     ManagerID INT REFERENCES Organization(EmployeeID)
-- );


-- CEO
INSERT INTO Organization (FirstName, LastName, Department, ManagerID)
VALUES ('Allen', 'Smith', 'Executive', NULL);  -- EmployeeID = 1

-- VPs reporting to CEO
INSERT INTO Organization (FirstName, LastName, Department, ManagerID)
VALUES 
('Bob', 'Johnson', 'Sales', 1),
('Carol', 'Williams', 'Engineering', 1),
('David', 'Brown', 'HR', 1);

-- Directors under each VP (3 VPs * 3–4 Directors)
INSERT INTO Organization (FirstName, LastName, Department, ManagerID)
SELECT 
    'Director_' || i, 'Lastname_' || i, 
    CASE 
        WHEN i <= 6 THEN 'Sales'
        WHEN i <= 10 THEN 'Engineering'
        ELSE 'HR'
    END,
    CASE 
        WHEN i <= 6 THEN 2
        WHEN i <= 10 THEN 3
        ELSE 4
    END
FROM generate_series(5, 14) AS s(i);

-- Managers under each Director (30 total)
INSERT INTO Organization (FirstName, LastName, Department, ManagerID)
SELECT 
    'Manager_' || i, 'Lastname_' || i, 
    CASE 
        WHEN i <= 24 THEN 'Sales'
        WHEN i <= 32 THEN 'Engineering'
        ELSE 'HR'
    END,
    CASE 
        WHEN i <= 24 THEN (i % 10) + 5  -- director 5-14
        WHEN i <= 32 THEN (i % 5) + 7
        ELSE (i % 4) + 11
    END
FROM generate_series(15, 44) AS s(i);

-- Engineers/Staff under Managers (55 employees)
INSERT INTO Organization (FirstName, LastName, Department, ManagerID)
SELECT 
    'Engineer_' || i, 'Lastname_' || i,
    CASE 
        WHEN i <= 60 THEN 'Sales'
        WHEN i <= 80 THEN 'Engineering'
        ELSE 'HR'
    END,
    (i % 30) + 15  -- managers 15–44
FROM generate_series(45, 99) AS s(i);



WITH RECURSIVE RecursiveOrganizationCTE AS (
    SELECT EmployeeID, FirstName, LastName, Department, ManagerID, 1 AS Level
    FROM Organization
    WHERE ManagerID IS NULL
    
    UNION ALL
    
    SELECT e.EmployeeID, e.FirstName, e.LastName, e.Department, e.ManagerID, r.Level + 1
    FROM Organization e
    JOIN RecursiveOrganizationCTE r ON e.ManagerID = r.EmployeeID
)
SELECT * 
FROM RecursiveOrganizationCTE
ORDER BY Level, ManagerID NULLS FIRST, EmployeeID;



WITH Recursive RecursiveOrganizationCTE AS
(
    SELECT EmployeeID, FirstName, LastName, Department,ManagerID
    FROM Organization
    WHERE ManagerID IS NULL
    UNION ALL
   
    SELECT e.EmployeeID, e.FirstName, e.LastName, e.department,e.ManagerID
    FROM Organization e
    JOIN RecursiveOrganizationCTE r ON e.ManagerID = r.EmployeeID
)
--Show the records stored inside  the CTE we created above
SELECT *
FROM RecursiveOrganizationCTE;

/*

SELECT * FROM Organization
*/


--SELECT to_char(current_date, 'Day') AS day_name FROM your_table;
--SELECT extract(dow FROM current_date::date);
-- returns 1 = Monday (Note: PostgreSQL: Sunday=0 by default)
--SELECT to_char(current_date::date, 'FMDay') AS day_name;
WITH RECURSIVE DaysofWeek(x, WeekDays) AS (
    SELECT 
        0, 
        TO_CHAR(current_date, 'FMDay')  -- base case: current date day name, no trailing spaces
    UNION ALL
    SELECT 
        x + 1, 
        TO_CHAR(current_date + (x + 1) * INTERVAL '1 day', 'FMDay')
    FROM DaysofWeek 
    WHERE x < 6
)
SELECT WeekDays FROM DaysofWeek;



WITH Recursive NumbersCTE AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number + 1
    FROM NumbersCTE
    WHERE Number < 50   -- Intent to go up to 50, but recursion limited
)
SELECT Number
FROM NumbersCTE
OPTION (MAXRECURSION 10);