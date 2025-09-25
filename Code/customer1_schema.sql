-- Table: sales.customer

-- DROP TABLE IF EXISTS sales.customer;

CREATE TABLE IF NOT EXISTS sales.customer1
(
    customerid integer NOT NULL DEFAULT nextval('sales.customer_customerid_seq'::regclass),
    personid integer,
    storeid integer,
    territoryid integer,
	firstname varchar(20), 
	lastname varchar(20),
    rowguid uuid NOT NULL DEFAULT uuid_generate_v1(),
    modifieddate timestamp without time zone NOT NULL DEFAULT now(),
    CONSTRAINT "PK_Customer_CustomerID1" PRIMARY KEY (customerid),
    CONSTRAINT "FK_Customer_Person_PersonID1" FOREIGN KEY (personid)
        REFERENCES person.person (businessentityid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "FK_Customer_SalesTerritory_TerritoryID1" FOREIGN KEY (territoryid)
        REFERENCES sales.salesterritory (territoryid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "FK_Customer_Store_StoreID1" FOREIGN KEY (storeid)
        REFERENCES sales.store (businessentityid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS sales.customer1
    OWNER to postgres;

COMMENT ON TABLE sales.customer1
    IS 'Current customer information. Also see the Person and Store tables.';

COMMENT ON COLUMN sales.customer1.customerid
    IS 'Primary key.';

COMMENT ON COLUMN sales.customer1.personid
    IS 'Foreign key to Person.BusinessEntityID';

COMMENT ON COLUMN sales.customer1.storeid
    IS 'Foreign key to Store.BusinessEntityID';

COMMENT ON COLUMN sales.customer1.territoryid
    IS 'ID of the territory in which the customer is located. Foreign key to SalesTerritory.SalesTerritoryID.';