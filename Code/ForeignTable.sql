CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER my_foreign_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (
    host '127.0.0.1',
    dbname 'remotedb',
    port '5432'
);

CREATE USER MAPPING FOR CURRENT_USER
SERVER my_foreign_server
OPTIONS (
    user 'remote_user',
    password 'remote_password'
);

CREATE USER MAPPING FOR sam ... --? check


CREATE FOREIGN TABLE foreign_employees (
    id INT,
    name TEXT,
    department TEXT
)
SERVER my_foreign_server
OPTIONS (schema_name 'public', table_name 'employees');


