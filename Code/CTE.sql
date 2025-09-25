--CTE
CREATE TABLE sales_cte (
  id SERIAL PRIMARY KEY,
  region VARCHAR(50),
  sales INT,
  sale_date DATE
);

INSERT INTO sales_cte (region, sales, sale_date) VALUES
('East', 100, '2024-01-01'),
('East', 200, '2024-01-02'),
('West', 150, '2024-01-01'),
('West', 300, '2024-01-02'),
('North', 120, '2024-01-03'),
('South', 180, '2024-01-04');


WITH region_sales AS (
  SELECT
    region,
    SUM(sales) AS total_sales
  FROM sales_cte
  GROUP BY region
)
SELECT * FROM region_sales;






/*CTE Problems*/

/*Problem 1: Get total sales per salesperson using CTE
Problem Statement:
Write a query to get the total sales for each salesperson, using a CTE.
*/
WITH total_sales AS (
SELECT
	employee,
	SUM(sale_amount) AS total_amount
FROM public.sales1
GROUP BY employee
order by total_amount desc
)
SELECT * FROM total_sales;


/*Problem 2: Get salespersons whose total sales > 2500 using CTE

Problem Statement:
Use a CTE to filter salespersons whose total sales exceed 2500.
*/


WITH total_sales AS (
    SELECT
        employee,
        SUM(sale_amount) AS total_amount
    FROM sales1
    GROUP BY employee
)
SELECT *
FROM total_sales
WHERE total_amount > 700;


/*
Problem 3: Rank salespersons within each region using CTE + window functions

Problem Statement:
Rank salespersons within each region by sales amount.
*/
select * from sales1;

WITH ranked_sales AS (
    SELECT
        s.region,
        s.employee_id,
        s.amount,
        RANK() OVER (PARTITION BY s.region ORDER BY s.amount DESC) AS rank_in_region
    FROM sales s
	left join employees e on e.id = s.employee_id
)
SELECT * FROM ranked_sales;

select * from employees

/*
CREATE TABLE stock_price (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    price NUMERIC(10, 2) NOT NULL
);
*/

/*Problem 5: Get top 1 salesperson by region using CTE

Problem Statement:
Use a CTE to get the top salesperson by amount in each region.

select * from sales
*/
WITH ranked_sales AS (
    SELECT
        region,
        employee_id,
        amount,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY amount DESC) AS rn
		--RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS rn
    FROM sales
)
SELECT region, employee_id, amount
FROM ranked_sales
WHERE rn = 1;


/*Symmetrical Pari*/
SELECT F1.X, F1.Y
FROM Functions F1
WHERE EXISTS (
    SELECT 1
    FROM Functions F2
    WHERE F1.X = F2.Y AND F1.Y = F2.X
)

AND F1.X <= F1.Y;


WITH CTE AS (
  SELECT X, Y, ROW_NUMBER() OVER (ORDER BY X, Y) AS rn
  FROM Functions
)
SELECT DISTINCT f1.X, f1.Y
FROM CTE f1
JOIN CTE f2
  ON f1.X = f2.Y AND f1.Y = f2.X
WHERE f1.rn <> f2.rn   
  AND f1.X <= f1.Y     
ORDER BY f1.X, f1.Y;
