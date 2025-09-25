SELECT 
    s.salesorderid,
    TO_CHAR(s.orderdate, 'YYYY-MM-DD') AS order_date,
    --c.firstname || ' ' || c.lastname AS customer_name,
	 cd.firstname,
    p.name AS product_name,
    s.orderqty,
    s.unitprice,
    s.total_price
FROM etl_stage_sales s
LEFT JOIN sales.customer c ON s.customerid = c.customerid
LEFT JOIN production.product p ON s.productid = p.productid
LEFT JOIN sales.customer cd on cd.customerid = c.customerid
WHERE cd.firstname is not null;

SELECT 
   
	cd.firstname,
    p.name AS product_name,
    s.orderqty
 
FROM etl_stage_sales s
LEFT JOIN sales.customer c ON s.customerid = c.customerid
LEFT JOIN production.product p ON s.productid = p.productid
LEFT JOIN sales.customer cd on cd.customerid = c.customerid
WHERE cd.firstname is not null;

select * from sales.customer c where  c.firstname is not null;
select * from sales.customer c where  c.lastname is not null;

SELECT  * from sales.customer c
 
	WHERE c.customerid=1  
	
UPDATE sales.customer c
	SET  c.firstname='Dhandapani', c.lastname='Krishnamurthi'
	WHERE c.customerid=1  
	
UPDATE sales.customer 
	SET  
		firstname='Dhandapani', 
		lastname='Krishnamurthi'
	WHERE customerid=1  
	
	
