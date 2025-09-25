-- Table: sales.salesorderheader
INSERT INTO sales.salesaudit_price_change (
    prudctid ,
    pricechangedon ,
    price ,
    qty 
) VALUES
(43659,  '2025-08-08', 450.4589, 3),
(43659,  '2025-08-08', 450.4589, 2),
(43659,  '2025-08-08', 450.4589, 2),
(43668,  '2025-08-08', 183.9382, 1),
(43668,  '2025-08-08', 28.8404, 1);

select * from sales.salesorderdetail
select * from sales.salesaudit_price_change


select TO_CHAR(pricechangedon,'MM'),sod.salesorderid,soa.price,  soa.pricechangedon,soa.price,soa.qty
from sales.salesorderdetail sod
right join sales.salesaudit_price_change soa on sod.salesorderid = soa.prudctid
where pricechangedon between 

--TO_CHAR(pricechangedon,'MM') and TO_CHAR(pricechangedon,'MM')



price, productid,qty, pricechangedon
-- DROP TABLE IF EXISTS sales.salesorderheader;

CREATE TABLE IF NOT EXISTS sales.salesaudit_price_change
(
    prudctid integer,
    pricechangedon timestamp without time zone NOT NULL,
    price numeric,
    qty numeric
   
)
