CREATE TABLE RSL_demo_emp (
    id SERIAL PRIMARY KEY,
    name TEXT,
    department TEXT,
    created_by TEXT  -- user who created this row
);


CREATE ROLE sam LOGIN PASSWORD 'sam123';
CREATE ROLE ben LOGIN PASSWORD 'ben123';

ALTER TABLE RSL_demo_emp ENABLE ROW LEVEL SECURITY;


CREATE POLICY employee_policy
ON RSL_demo_emp
FOR SELECT
USING (created_by = current_user);


CREATE POLICY insert_policy
ON RSL_demo_emp
FOR INSERT
WITH CHECK (created_by = current_user);


GRANT SELECT, INSERT ON RSL_demo_emp TO sam, ben;

-- Set session as  (simulated)
SET ROLE sam;

-- Insert a row
INSERT INTO RSL_demo_emp (name, department, created_by)
VALUES ('Samsonite James', 'HR', 'sam');

-- Query rows (only see your own)
SELECT * FROM RSL_demo_emp;

select current_user

SELECT column_name, column_default
FROM information_schema.columns
WHERE table_name = 'rsl_demo_emp';

-- Grant permissions on the table
GRANT INSERT, SELECT ON rsl_demo_emp TO sam;

-- Grant permission on the sequence
GRANT USAGE, SELECT, UPDATE ON SEQUENCE rsl_demo_emp_id_seq TO sam;



