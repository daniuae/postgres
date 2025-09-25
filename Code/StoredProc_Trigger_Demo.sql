--Step #1
-- Employee Table
CREATE TABLE employees_sptr1 (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    salary NUMERIC(10, 2)
);

-- Audit Table
CREATE TABLE salary_audit_sptr1 (
    audit_id SERIAL PRIMARY KEY,
    emp_id INT,
    old_salary NUMERIC(10, 2),
    new_salary NUMERIC(10, 2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--Step #2
INSERT INTO employees_sptr1 (emp_name, salary)
VALUES 
('Om', 50000),
('Shivam', 60000),
('Biju', 70000);


CREATE OR REPLACE FUNCTION salary_change_logging1()
RETURNS TRIGGER AS $$
BEGIN
    -- Only log if salary actually changed
    IF NEW.salary <> OLD.salary THEN
        INSERT INTO salary_audit_sptr1(emp_id, old_salary, new_salary)
        VALUES (OLD.emp_id, OLD.salary, NEW.salary);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--Step #4 

CREATE TRIGGER trg_salary_update1_before
	BEFORE UPDATE ON employees_sptr1
	FOR EACH ROW
	WHEN (OLD.salary IS DISTINCT FROM NEW.salary)
EXECUTE FUNCTION salary_change_logging1();

--Check for insert into 
-- CREATE TRIGGER trg_salary_insert
-- 	AFTER INSERT ON employees_sptr1
-- 	FOR EACH ROW
-- EXECUTE FUNCTION salary_change_logging1();
CREATE TABLE employee_3_audit_log (
    audit_id SERIAL PRIMARY KEY,
    employee_id INT,
    name VARCHAR(100),
    department VARCHAR(50),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type VARCHAR(10)
);
CREATE OR REPLACE FUNCTION log_employee_3_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO employee_3_audit_log (employee_id, name, department, action_type)
    VALUES (NEW.id, NEW.name, NEW.department, 'INSERT');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

ALTER TRIGGER trg_log_employee_insert
AFTER INSERT ON employees11
FOR EACH ROW
EXECUTE FUNCTION log_employee_insert();

CREATE TABLE employees11 (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50)
);


INSERT INTO public.employees11 (emp_name, department) VALUES ('Teju', 'Finance');

SELECT * FROM employee_audit;

--employee_audit_log

-- CREATE OR REPLACE FUNCTION log_employee_sptr_insert()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     INSERT INTO employee_audit (employee_id, name, department, action_type)
--     VALUES (NEW.id, NEW.name, NEW.department, 'INSERT');
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

--Step #5

/*
Select * from employees_sptr1
Select * from salary_audit_sptr1
*/

UPDATE employees_sptr1
SET salary = 75000
WHERE emp_id = 2;

UPDATE employees_sptr1
SET salary = 90000
WHERE emp_id = 1;


UPDATE employees_sptr1
SET salary = 75000
WHERE emp_id = 3;
/*Check the audit log*/

SELECT * FROM salary_audit_sptr1;
