CREATE TABLE categories (id int primary key,name text not null);
CREATE TABLE products (id int primary key, name text not null,
price int default 0.0,category_id int not null, 
CONSTRAINT fk_Category_id FOREIGN KEY (Category_id) REFERENCES categories(id));

CHECK (price >= 0);

INSERT INTO products (id, name, price, category_id) VALUES (1, 'Test Product', 10, 999);