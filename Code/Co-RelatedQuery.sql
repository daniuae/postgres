SELECT E1.Name, E1.Salary, E1.department
FROM Employees E1
WHERE E1.Salary > (
SELECT AVG(E2.Salary)
FROM Employees E2
WHERE E2.department = E1.department -- Correlated part:
E2.department depends on E1.department
);
-- Find the employees who are the highest paid in their department
SELECT E1.Name, E1.Salary, E1.department
FROM Employees E1
WHERE E1.Salary = (
SELECT MAX(E2.Salary)
FROM Employees E2
WHERE E2.department = E1.department
);