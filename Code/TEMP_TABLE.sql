CREATE TEMP TABLE temp_sales (
    id SERIAL PRIMARY KEY,
    region VARCHAR(50),
    department VARCHAR(50),
    revenue INT
);

INSERT INTO temp_sales (region, department, revenue) VALUES
('North', 'IT', 10000),
('North', 'HR', 7000),
('South', 'IT', 12000),
('South', 'HR', 6000),
('South', 'Marketing', 8000);


SELECT * FROM temp_sales;


SELECT region, SUM(revenue) AS total_revenue
FROM temp_sales
GROUP BY region;


DROP TABLE temp_sales;
