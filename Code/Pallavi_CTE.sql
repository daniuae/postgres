-- SIMPLE CTE
WITH SALES_DATA_CTE AS(

	SELECT  salesorderid,sum(orderqty) as  Total_Quantity, modifieddate
	FROM  sales.salesorderdetail
	WHERE  TO_CHAR(modifieddate,'YYYY') = '2012'	
	group by  salesorderid,modifieddate
	order by Total_Quantity desc

)
select * from SALES_DATA_CTE;


SELECT EXTRACT(DAY FROM MAX(modifieddate)-MIN(modifieddate)) AS DateDifference
FROM   sales.salesorderdetail

SELECT EXTRACT(DAY FROM MAX(modifieddate)-MIN(modifieddate)) AS DateDifference
FROM   sales.salesorderdetail

--MULTIPLE CTE

WITH ProductSales AS (
    -- Step 1: Calculate total sales for each product
    SELECT ProductID, SUM(orderqty * unitprice) AS TotalSales
    FROM Sales.salesorderdetail
    GROUP BY ProductID
	ORDER BY TotalSales DESC
),
AverageSales AS (
    -- Step 2: Calculate the average total sales across all products
    SELECT AVG(TotalSales) AS AverageTotalSales
    FROM ProductSales
),

--select * from AverageSales
HighSalesProducts AS (
    -- Step 3: Filter products with above-average total sales
    SELECT ProductID, TotalSales
    FROM ProductSales
    WHERE TotalSales > (SELECT AverageTotalSales FROM AverageSales)
)
--select * from HighSalesProducts
-- Step 4: Rank the high-sales products
SELECT ProductID, TotalSales, RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
FROM HighSalesProducts;

SELECT 
soh.salesorderid,
soh.shipdate,

sod.salesorderid,
sod.orderqty
FROM sales.salesorderheader soh INNER JOIN sales.salesorderdetail sod
on soh.salesorderid = sod.salesorderid
WHERE soh.salesorderid ='43659' 





