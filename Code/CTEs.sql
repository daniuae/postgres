CREATE TABLE employee_audit_log (
    audit_id SERIAL PRIMARY KEY,
    employee_id INT,
    name VARCHAR(100),
    department VARCHAR(50),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type VARCHAR(10)
);

CREATE OR REPLACE FUNCTION log_employee_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO employee_3_audit_log (employee_id, name, department, action_type)
    VALUES (NEW.id, NEW.name, NEW.department, 'INSERT');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_employee3_insert
AFTER INSERT ON employees11
FOR EACH ROW
EXECUTE FUNCTION log_employee_insert();

CREATE TABLE employees11 (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50)
);


INSERT INTO public.employees11 (name, department) VALUES ('Teju', 'Finance');

SELECT * FROM employees11;

SELECT * FROM employee_3_audit_log