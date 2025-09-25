-- Main table _ddemo
CREATE TABLE employees_ddemo (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50)
);

-- Audit table _ddemo
CREATE TABLE employee_audit_ddemo (
    audit_id SERIAL PRIMARY KEY,
    employee_id INT,
    name VARCHAR(100),
    department VARCHAR(50),
    action_type VARCHAR(10),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_employee_delete_ddemo()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO employee_audit_ddemo (employee_id, name, department, action_type)
    VALUES (OLD.id, OLD.name, OLD.department, 'DELETE');
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_log_employee_delete_ddemo
AFTER DELETE ON employees_ddemo
FOR EACH ROW
EXECUTE FUNCTION log_employee_delete_ddemo();


-- Insert sample data
INSERT INTO employees_ddemo (name, department) VALUES
('Srisha', 'HR'),
('Devji', 'Engineering');

-- Delete one record
DELETE FROM employees_ddemo WHERE name = 'Srisha';

-- Check the audit log
SELECT * FROM employee_audit_ddemo;
SELECT * FROM employees_ddemo;
