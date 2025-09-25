-- Table: public.nse_market_data

-- DROP TABLE IF EXISTS public.nse_market_data;

CREATE TABLE IF NOT EXISTS public.nse_market_data
(
    trade_date date,
    symbol character varying(20) COLLATE pg_catalog."default",
    series character varying(10) COLLATE pg_catalog."default",
    prev_close numeric(10,2),
    open_price numeric(10,2),
    high_price numeric(10,2),
    low_price numeric(10,2),
    last_price numeric(10,2),
    close_price numeric(10,2),
    vwap numeric(10,2),
    volume bigint,
    turnover numeric(20,2),
    trades bigint,
    deliverable_volume bigint,
    percent_deliverable numeric(5,2)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.nse_market_data
    OWNER to postgres;



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
