SELECT salesorderid, salesorderdetailid, carriertrackingnumber, orderqty, productid, specialofferid, unitprice, unitpricediscount, rowguid, modifieddate
	FROM sales.salesorderdetail;

SELECT  * from sales.salesorderdetail
	--SET  unitprice=0, orderqty=0
	WHERE salesorderid=43666 and salesorderdetailid=75;

	
UPDATE sales.salesorderdetail
	SET  unitprice=0, orderqty=0
	WHERE salesorderid=43666 and salesorderdetailid=75;