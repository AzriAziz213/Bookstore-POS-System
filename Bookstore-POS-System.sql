# Schema generation Query

### customers

CREATE TABLE customers(
	id serial PRIMARY KEY
	, name VARCHAR(50) UNIQUE NOT NULL
	, email VARCHAR(50) UNIQUE
	, tel VARCHAR(50)
	, created_at TIMESTAMP NOT NULL
	, updated_at TIMESTAMP NOT NULL
)

### invoices

CREATE TABLE invoices(
	id serial PRIMARY KEY
	, number VARCHAR(50) UNIQUE NOT NULL
	, sub_total decimal(12,2)
	, tax_total decimal(12,2)
	, total decimal(12,2)
	, customer_id INTEGER REFERENCES customers(id)
	, created_at TIMESTAMP NOT NULL
	, updated_at TIMESTAMP NOT NULL
)

### invoice_line

CREATE TABLE invoice_lines(
	id SERIAL PRIMARY KEY
	, description VARCHAR(50) 
  	, unit_price DECIMAL(12,2)
	, quantity INTEGER
	, sub_total DECIMAL(12,2)
	, tax_total DECIMAL(12,2)
	, total DECIMAL(12,2)
	, tax_id VARCHAR(50)
	, sku_id INTEGER
	, invoice_id INTEGER REFERENCES invoices(id)
)

### Number of customers purchasing more than 5 books

WITH customers_purchased AS(
SELECT
	t1.name
	, SUM(t3.quantity) AS books_purchased
FROM customers AS t1
INNER JOIN invoices AS t2 ON t1.id = t2.customer_id
INNER JOIN invoice_lines AS t3 ON t2.id = t3.invoice_id
GROUP BY 1
)

SELECT COUNT(*) AS customers_num
FROM customers_purchased
WHERE books_purchased > 5

### List of customers who never purchased anything

WITH customers_purchased AS(
SELECT
	t1.name
	, SUM(t3.quantity) AS books_purchased
FROM customers AS t1
FULL OUTER JOIN invoices AS t2 ON t1.id = t2.customer_id
FULL OUTER JOIN invoice_lines AS t3 ON t2.id = t3.invoice_id
GROUP BY 1
)

SELECT name
FROM customers_purchased
WHERE books_purchased IS NULL
WHERE books_purchased IS NULL

### List of book purchased with the users

WITH customers_purchased AS(
SELECT
	t3.description
	, t1.name
FROM customers AS t1
INNER JOIN invoices AS t2 ON t1.id = t2.customer_id
INNER JOIN invoice_lines AS t3 ON t2.id = t3.invoice_id
)

SELECT *
FROM customers_purchased
ORDER BY 1,2
