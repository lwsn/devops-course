-- Create database
CREATE DATABASE public;

-- Connect to the database
\c public;

-- Create table
CREATE TABLE assignment2 (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);

-- Insert row
INSERT INTO assignment2 (key, value)
VALUES ('greeting', 'congratulations, you got access to the database :)');

-- Create read-only role
CREATE ROLE readonly_user WITH LOGIN PASSWORD 'public';

-- Grant read-only access to the table
GRANT CONNECT ON DATABASE public TO readonly_user;
GRANT USAGE ON SCHEMA public TO readonly_user;
GRANT SELECT ON assignment2 TO readonly_user;
