# infi
CREATE TABLE customers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE,
    country TEXT
);
Insert data
sql
Copy code
INSERT INTO customers (name, email, country)
VALUES ('Alice', 'alice@mail.com', 'Germany');