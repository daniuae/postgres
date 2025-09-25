-- Table: sales.salesorderdetail

-- DROP TABLE IF EXISTS sales.salesorderdetail;

CREATE TABLE IF NOT EXISTS sales.salesorderdetailnew
(
    salesorderid integer NOT NULL,
    salesorderdetailid integer NOT NULL DEFAULT nextval('sales.salesorderdetail_salesorderdetailid_seq'::regclass),
    carriertrackingnumber character varying(25) COLLATE pg_catalog."default",
    orderqty smallint NOT NULL,
    productid integer NOT NULL,
    specialofferid integer NOT NULL,
    unitprice numeric NOT NULL,
    unitpricediscount numeric NOT NULL DEFAULT 0.0,
    rowguid uuid NOT NULL DEFAULT uuid_generate_v1(),
    modifieddate timestamp without time zone NOT NULL DEFAULT now(),
	linetotal numeric NOT NULL DEFAULT 0.0,
	--added by Dani linetotal numeric NOT NULL DEFAULT 0.0
    CONSTRAINT "PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailIDnew" PRIMARY KEY (salesorderid, salesorderdetailid),
    CONSTRAINT "FK_SalesOrderDetail_SalesOrderHeader_SalesOrderIDnew" FOREIGN KEY (salesorderid)
	
        REFERENCES sales.salesorderheader (salesorderid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT "FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductIDnew" FOREIGN KEY (specialofferid, productid)
        REFERENCES sales.specialofferproduct (specialofferid, productid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "CK_SalesOrderDetail_OrderQtynew" CHECK (orderqty > 0),
    CONSTRAINT "CK_SalesOrderDetail_UnitPricenew" CHECK (unitprice >= 0.00),
    CONSTRAINT "CK_SalesOrderDetail_UnitPriceDiscountnew" CHECK (unitpricediscount >= 0.00)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS sales.salesorderdetailnew
    OWNER to postgres;

COMMENT ON TABLE sales.salesorderdetailnew
    IS 'Individual products associated with a specific sales order. See SalesOrderHeader.';

COMMENT ON COLUMN sales.salesorderdetailnew.salesorderid
    IS 'Primary key. Foreign key to SalesOrderHeader.SalesOrderID.';

COMMENT ON COLUMN sales.salesorderdetailnew.salesorderdetailid
    IS 'Primary key. One incremental unique number per product sold.';

COMMENT ON COLUMN sales.salesorderdetailnew.carriertrackingnumber
    IS 'Shipment tracking number supplied by the shipper.';

COMMENT ON COLUMN sales.salesorderdetailnew.orderqty
    IS 'Quantity ordered per product.';

COMMENT ON COLUMN sales.salesorderdetailnew.productid
    IS 'Product sold to customer. Foreign key to Product.ProductID.';

COMMENT ON COLUMN sales.salesorderdetailnew.specialofferid
    IS 'Promotional code. Foreign key to SpecialOffer.SpecialOfferID.';

COMMENT ON COLUMN sales.salesorderdetailnew.unitprice
    IS 'Selling price of a single product.';

COMMENT ON COLUMN sales.salesorderdetailnew.unitpricediscount
    IS 'Discount amount.';

-- Trigger: trg_log_orderqty_update

-- DROP TRIGGER IF EXISTS trg_log_orderqty_update ON sales.salesorderdetail;

CREATE OR REPLACE TRIGGER trg_log_orderqty_update
    AFTER UPDATE 
    ON sales.salesorderdetailnew
    FOR EACH ROW
    EXECUTE FUNCTION public.log_orderqty_update();