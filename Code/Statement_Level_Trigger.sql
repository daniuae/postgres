/*
A statement-level trigger runs once per SQL statement, regardless of how many rows are affected.
*/

CREATE TABLE sales_order_audit_log (
    log_id SERIAL PRIMARY KEY,
    action_type TEXT,
    triggered_by TEXT,
    event_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_sales_order_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO sales_order_audit_log (
        action_type,
        triggered_by
    )
    VALUES (
        'INSERT on salesorderheader',
        CURRENT_USER
    );

    RETURN NULL;  -- Statement-level trigger doesn't return a row
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_salesorderheader_insert_stmt
AFTER INSERT ON sales.salesorderheader
FOR STATEMENT
EXECUTE FUNCTION log_sales_order_insert();


-- Insert one or more rows
INSERT INTO sales.salesorderheader (
    revisionnumber, orderdate, duedate, shipdate, status,
    onlineorderflag, customerid, salespersonid, territoryid,
    billtoaddressid, shiptoaddressid, shipmethodid, creditcardid,
    creditcardapprovalcode, currencyrateid, subtotal, taxamt, freight,
    totaldue, comment, rowguid, modifieddate
)
SELECT 
    1, CURRENT_DATE, CURRENT_DATE + 5, CURRENT_DATE + 3, 5,
    true, customerid, 276, 1,
    29559, 29559, 5, 1077,
    'APPROVED', NULL, 1000, 50, 10,
    1060, NULL, gen_random_uuid(), CURRENT_TIMESTAMP
FROM sales.customer
LIMIT 100;

-- Check audit log
SELECT * FROM sales_order_audit_log;

