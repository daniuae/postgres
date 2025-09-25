CREATE TABLE public.sales_1 (
    sale_id      serial PRIMARY KEY,
    employee_id  integer NOT NULL,
    customer_id  integer NOT NULL,
    sales_date   date NOT NULL,
    amount       numeric(10,2) NOT NULL,
    commission   numeric(10,2) NOT NULL,
    product      varchar(100) NOT NULL,
    region       varchar(50),
    notes        text
);



-- Start a transaction
BEGIN;

	-- Example operation: Insert a new sale record
	INSERT INTO public.sales_1 (employee_id, customer_id, sales_date, amount, commission, product, region, notes)
	VALUES (123, 223, '2025-03-10', 1450.00, 145.00, 'Smartwatch Series 6', 'North', 'Demo insert for transaction');
	
	-- Check the result before committing/rolling back
	SELECT * FROM public.sales_1 WHERE employee_id = 123;
	--DELETE FROM public.sales_1 WHERE employee_id = 123;

-- If everything is correct, commit the changes:
COMMIT;
-- The new record is now permanently saved to the database[3][1][8].

-- Or, if something is wrong, roll back the changes:
ROLLBACK;
-- The new record is undone, as if the insert never happened[1][3][9].


--select * from public.sales_1
BEGIN;

-- First insert: this will remain even if we roll back to the later savepoint
INSERT INTO public.sales_1 (employee_id, customer_id, sales_date, amount, commission, product, region, notes)
VALUES (125, 225, '2025-03-12', 1600.00, 160.00, 'Tablet Pro', 'East', 'Initial sale in transaction');

-- Create a SAVEPOINT
SAVEPOINT after_first_insert;

-- Second insert: this one may be undone
INSERT INTO public.sales_1 (employee_id, customer_id, sales_date, amount, commission, product, region, notes)
VALUES (126, 226, '2025-03-13', 500.00, 50.00, 'Bluetooth Speaker', 'West', 'Will roll back this insert');

-- Oops! Suppose we made a mistake, so we want to undo the second insert:
ROLLBACK TO SAVEPOINT after_first_insert;

-- The second insert is now undone, but the first remains.

-- Third insert: this one will now be included
INSERT INTO public.sales_1 (employee_id, customer_id, sales_date, amount, commission, product, region, notes)
VALUES (127, 227, '2025-03-14', 950.00, 95.00, 'DSLR Camera', 'North', 'This record stays');

-- Finish the transaction—now only the first and third inserts are saved
COMMIT;

