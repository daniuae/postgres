WITH Recursive RecursiveOrganizationCTE AS
(
SELECT EmployeeID, FirstName, LastName,
Department,ManagerID
FROM Organization
WHERE ManagerID IS NULL
UNION ALL
SELECT e.EmployeeID, e.FirstName, e.LastName,
e.department,e.ManagerID
FROM Organization e
JOIN RecursiveOrganizationCTE r ON e.ManagerID =
r.EmployeeID
)
--Show the records stored inside the CTE we created above
SELECT *
FROM RecursiveOrganizationCTE;


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
FROM NumbersCTE;

--OPTION (MAXRECURSION 10);