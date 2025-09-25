-- ================================
-- 1. Function: calculate_discount
-- ================================
CREATE OR REPLACE FUNCTION calculate_discount(order_qty INT)
RETURNS NUMERIC AS $$
BEGIN
    IF order_qty >= 50 THEN
        RETURN 0.15;  -- 15% discount
    ELSIF order_qty >= 20 THEN
        RETURN 0.10;  -- 10% discount
    ELSE
        RETURN 0.05;  -- 5% discount
    END IF;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- 2. Procedure: insert_discounted_order
-- =============================================
CREATE OR REPLACE PROCEDURE insert_discounted_order(
    p_orderid INT,
    p_productid INT,
    p_qty INT,
    p_unitprice NUMERIC,
	p_specialofferid INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_discount NUMERIC;
    v_total NUMERIC;
BEGIN
    v_discount := calculate_discount(p_qty);
    v_total := p_unitprice * p_qty * (1 - v_discount);

    INSERT INTO sales.salesorderdetailnew (
        salesorderid, productid, orderqty, unitprice, linetotal,specialofferid
    )
    VALUES (
        p_orderid, p_productid, p_qty, p_unitprice, v_total,p_specialofferid
    );
END;
$$;

-- =====================================
-- 3. Audit Table: audit_orderqty_changes
-- =====================================
CREATE TABLE IF NOT EXISTS audit_orderqty_changes (
    audit_id SERIAL PRIMARY KEY,
    salesorderid INT,
    old_qty INT,
    new_qty INT,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================
-- 4. Trigger Function: log_orderqty_update
-- =========================================
CREATE OR REPLACE FUNCTION log_orderqty_update()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.orderqty <> NEW.orderqty THEN
        INSERT INTO audit_orderqty_changes (
            salesorderid, old_qty, new_qty
        )
        VALUES (
            OLD.salesorderid, OLD.orderqty, NEW.orderqty
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================
-- 5. Trigger: Attach to table
-- ============================
DROP TRIGGER IF EXISTS trg_log_orderqty_update ON sales.salesorderdetail;

CREATE TRIGGER trg_log_orderqty_update
AFTER UPDATE ON sales.salesorderdetail
FOR EACH ROW
EXECUTE FUNCTION log_orderqty_update();

-- ============================
-- 6. Test Data & Verification
-- ============================

-- select * from sales.salesorderdetail WHERE salesorderid = 43659 AND productid = 776;
-- select * from sales.salesorderdetailnew WHERE salesorderid = 43659 AND productid = 776;
-- select salesorderid, productid, orderqty, unitprice from sales.salesorderdetail limit 1
--select * from sales.specialofferproduct
/*select  2024.994 * 25 * (1 - calculate_discount(25))
from sales.salesorderdetail WHERE salesorderid = 43659 AND productid = 776;
*/

/* INSERT INTO sales.salesorderdetailnew (
        salesorderid, productid, orderqty, unitprice, linetotal,specialofferid
    )
    VALUES (43659,776, 25, 100.00,10,1
       
    );
	 p_orderid, p_productid, p_qty, p_unitprice, v_total
	*/
-- Use this to call the procedure
-- CALL insert_discounted_order(43659, 776, 25, 100.00,1);

-- Update a record to trigger the audit
-- UPDATE sales.salesorderdetailnew
-- SET orderqty = 60
-- WHERE salesorderid = 43659 AND productid = 776;

-- Check the audit log
-- SELECT * FROM audit_orderqty_changes;
