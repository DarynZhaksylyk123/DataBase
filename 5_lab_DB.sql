-- Name: Zhaksylyk Daryn
-- Student ID: 25B031247


DROP TABLE IF EXISTS order_details CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS products_fk CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS publishers CASCADE;
DROP TABLE IF EXISTS employees_dept CASCADE;
DROP TABLE IF EXISTS student_courses CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS course_enrollments CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS products_catalog CASCADE;
DROP TABLE IF EXISTS employees CASCADE;


-- TASK 1.1

CREATE TABLE employees(
    employee_id INT,
    first_name TEXT,
    last_name TEXT,
    age INT CHECK (age BETWEEN 18 AND 65 ),
    salary NUMERIC CHECK ( salary > 0 )
);

-- TASK 1.2

CREATE TABLE products_catalog(
     product_id INT,
     product_name TEXT,
     regular_price NUMERIC,
     discount_price NUMERIC,
     CONSTRAINT valid_discount CHECK ( regular_price > 0 AND discount_price > 0 AND discount_price < regular_price)
);

-- TASK 1.3

CREATE TABLE bookings(
    booking_id INT,
    check_in_date DATE,
    check_out_date DATE,
    num_guests INT,
    CONSTRAINT checking CHECK ( check_out_date > check_in_date AND num_guests BETWEEN 1 AND 10 )
);

-- TASK 1.4

-- employees

-- Valid data
INSERT INTO employees (employee_id, first_name, last_name, age, salary)
VALUES
(1, 'John', 'Doe', 30, 50000),
(2, 'Jane', 'Smith', 45, 60000);

-- Invalid: age < 18
-- INSERT INTO employees VALUES (3, 'Too', 'Young', 17, 30000);
-- Violated: employees_age_check
-- Reason: age = 17, but the constraint requires age BETWEEN 18 AND 65.

-- Invalid: age > 65
-- INSERT INTO employees VALUES (4, 'Too', 'Old', 70, 40000);
-- Violated: employees_age_check
-- Reason: age = 70, but the constraint requires age BETWEEN 18 AND 65.

-- Invalid: salary <= 0
-- INSERT INTO employees VALUES (5, 'No', 'Salary', 30, 0);
-- Violated: employees_salary_check
-- Reason: salary = 0, but the constraint requires salary > 0.



-- products_catalog

-- Valid data
INSERT INTO products_catalog (product_id, product_name, regular_price, discount_price)
VALUES
(1, 'Laptop', 1200.00, 999.99),
(2, 'Mouse', 50.00, 39.99);

-- Invalid: regular_price <= 0
-- INSERT INTO products_catalog VALUES (3, 'Bad', 0, 10.00);
-- Violated: "valid_discount"
-- Reason: regular_price = 0, but the constraint requires regular_price > 0.

-- Invalid: discount_price <= 0
-- INSERT INTO products_catalog VALUES (4, 'Bad', 100.00, 0);
-- Violated: "valid_discount"
-- Reason: discount_price = 0, but the constraint requires discount_price > 0.

-- Invalid: discount_price >= regular_price
-- INSERT INTO products_catalog VALUES (5, 'Bad', 100.00, 100.00);
-- Violated: "valid_discount"
-- Reason: discount_price = 100.00 and regular_price = 100.00,
-- but the constraint requires discount_price < regular_price.



-- bookings

-- Valid data
INSERT INTO bookings (booking_id, check_in_date, check_out_date, num_guests)
VALUES
(1, '2025-01-10', '2025-01-12', 2),
(2, '2025-02-01', '2025-02-05', 4);

-- Invalid: num_guests < 1
-- INSERT INTO bookings VALUES (3, '2025-03-01', '2025-03-03', 0);
-- Violated: bookings_num_guests_check
-- Reason: num_guests = 0, but the constraint requires num_guests BETWEEN 1 AND 10.

-- Invalid: num_guests > 10
-- INSERT INTO bookings VALUES (4, '2025-03-01', '2025-03-03', 11);
-- Violated: bookings_num_guests_check
-- Reason: num_guests = 11, but the constraint requires num_guests BETWEEN 1 AND 10.

-- Invalid: check_out_date <= check_in_date
-- INSERT INTO bookings VALUES (5, '2025-03-05', '2025-03-01', 2);
-- Violated: bookings_check_out_date_check
-- Reason: check_out_date = '2025-03-01' and check_in_date = '2025-03-05',
-- but the constraint requires check_out_date > check_in_date.



-- TASK 2.1

CREATE TABLE customers (
    customer_id integer NOT NULL,
    email text NOT NULL,
    phone text,
    registration_date date NOT NULL
);

-- TASK 2.2

CREATE TABLE inventory (
    item_id integer NOT NULL,
    item_name text NOT NULL,
    quantity integer NOT NULL CHECK (quantity >= 0),
    unit_price numeric NOT NULL CHECK (unit_price > 0),
    last_updated timestamp NOT NULL
);

-- TASK 2.3

INSERT INTO customers (customer_id, email, phone, registration_date)
VALUES (1, 'alice@example.com', '555-1111', '2025-01-01');

INSERT INTO customers (customer_id, email, phone, registration_date)
VALUES (2, 'bob@example.com', NULL, '2025-01-02');

-- Invalid: NULL in email (NOT NULL column)
-- INSERT INTO customers VALUES (3, NULL, '555-3333', '2025-01-03');
-- ERROR:  null value in column "email" of relation "customers" violates not-null constraint
-- DETAIL:  Failing row contains (3, null, 555-3333, 2025-01-03).
-- Reason: email is declared NOT NULL, NULL is not allowed.

-- Invalid: NULL in customer_id (NOT NULL column)
-- INSERT INTO customers VALUES (NULL, 'carol@example.com', '555-4444', '2025-01-04');
-- ERROR:  null value in column "customer_id" of relation "customers" violates not-null constraint
-- DETAIL:  Failing row contains (null, carol@example.com, 555-4444, 2025-01-04).
-- Reason: customer_id is declared NOT NULL.

-- Invalid: NULL in registration_date (NOT NULL column)
-- INSERT INTO customers VALUES (5, 'dave@example.com', '555-5555', NULL);
-- ERROR:  null value in column "registration_date" of relation "customers" violates not-null constraint
-- DETAIL:  Failing row contains (5, dave@example.com, 555-5555, null).
-- Reason: registration_date is declared NOT NULL.


-- inventory

INSERT INTO inventory (item_id, item_name, quantity, unit_price, last_updated)
VALUES (1, 'Pen', 100, 1.50, '2025-01-01 10:00:00');

INSERT INTO inventory (item_id, item_name, quantity, unit_price, last_updated)
VALUES (2, 'Notebook', 0, 3.75, '2025-01-01 11:00:00');

-- Invalid: NULL in item_name (NOT NULL column)
-- INSERT INTO inventory VALUES (3, NULL, 10, 2.00, '2025-01-02 09:00:00');
-- ERROR:  null value in column "item_name" of relation "inventory" violates not-null constraint
-- DETAIL:  Failing row contains (3, null, 10, 2.00, 2025-01-02 09:00:00).
-- Reason: item_name is declared NOT NULL.

-- Invalid: NULL in quantity (NOT NULL column)
-- INSERT INTO inventory VALUES (4, 'Eraser', NULL, 0.50, '2025-01-02 09:00:00');
-- ERROR:  null value in column "quantity" of relation "inventory" violates not-null constraint
-- DETAIL:  Failing row contains (4, Eraser, null, 0.50, 2025-01-02 09:00:00).
-- Reason: quantity is declared NOT NULL.

-- Invalid: NULL in unit_price (NOT NULL column)
-- INSERT INTO inventory VALUES (5, 'Marker', 10, NULL, '2025-01-02 09:00:00');
-- ERROR:  null value in column "unit_price" of relation "inventory" violates not-null constraint
-- DETAIL:  Failing row contains (5, Marker, 10, null, 2025-01-02 09:00:00).
-- Reason: unit_price is declared NOT NULL.

-- Invalid: NULL in last_updated (NOT NULL column)
-- INSERT INTO inventory VALUES (6, 'Ruler', 20, 1.00, NULL);
-- ERROR:  null value in column "last_updated" of relation "inventory" violates not-null constraint
-- DETAIL:  Failing row contains (6, Ruler, 20, 1.00, null).
-- Reason: last_updated is declared NOT NULL.

-- Invalid: NULL in item_id (NOT NULL column)
-- INSERT INTO inventory VALUES (NULL, 'Glue', 15, 0.80, '2025-01-02 09:00:00');
-- ERROR:  null value in column "item_id" of relation "inventory" violates not-null constraint
-- DETAIL:  Failing row contains (null, Glue, 15, 0.80, 2025-01-02 09:00:00).
-- Reason: item_id is declared NOT NULL.



-- TASK 3.1

CREATE TABLE users (
    user_id integer,
    username text,
    email text,
    created_at timestamp
);

ALTER TABLE users
ADD CONSTRAINT unique_username UNIQUE (username);

ALTER TABLE users
ADD CONSTRAINT unique_email UNIQUE (email);

INSERT INTO users VALUES
(1, 'alice', 'alice@example.com', '2025-01-01 08:00:00'),
(2, 'bob', 'bob@example.com', '2025-01-01 09:00:00');

-- Invalid: duplicate username
-- INSERT INTO users VALUES (3, 'alice', 'alice2@example.com', '2025-01-02 08:00:00');
-- ERROR: violates unique constraint "unique_username"

-- Invalid: duplicate email
-- INSERT INTO users VALUES (4, 'charlie', 'alice@example.com', '2025-01-02 09:00:00');
-- ERROR: violates unique constraint "unique_email"



-- TASK 3.2
CREATE TABLE course_enrollments (
    enrollment_id integer,
    student_id integer,
    course_code text,
    semester text,
    CONSTRAINT unique_student_course_semester UNIQUE (student_id, course_code, semester)
);

INSERT INTO course_enrollments VALUES
(1, 101, 'CS101', '2025-Spring'),
(2, 101, 'MA101', '2025-Spring'),
(3, 102, 'CS101', '2025-Spring');

-- Invalid: duplicate combination
-- INSERT INTO course_enrollments VALUES (4, 101, 'CS101', '2025-Spring');
-- ERROR: violates unique constraint "unique_student_course_semester"



-- TASK 4.1
CREATE TABLE departments (
    dept_id integer PRIMARY KEY,
    dept_name text NOT NULL,
    location text
);

INSERT INTO departments VALUES
(1, 'HR', 'Building A'),
(2, 'IT', 'Building B'),
(3, 'Finance', 'Building C');

-- Invalid: duplicate dept_id
-- INSERT INTO departments VALUES (1, 'Sales', 'Building D');
-- ERROR: duplicate key value violates unique constraint "departments_pkey"

-- Invalid: NULL dept_id
-- INSERT INTO departments VALUES (NULL, 'Marketing', 'Building E');
-- ERROR: null value in column "dept_id" violates not-null constraint



-- TASK 4.2
CREATE TABLE student_courses (
    student_id integer,
    course_id integer,
    enrollment_date date,
    grade text,
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO student_courses VALUES
(101, 1, '2025-01-10', 'A'),
(101, 2, '2025-01-10', 'B'),
(102, 1, '2025-01-11', 'A');

-- Invalid: duplicate composite key
-- INSERT INTO student_courses VALUES (101, 1, '2025-01-12', 'C');
-- ERROR: duplicate key value violates unique constraint "student_courses_pkey"

-- Invalid: NULL in primary key column
-- INSERT INTO student_courses VALUES (NULL, 3, '2025-01-12', 'A');
-- ERROR: null value in column "student_id" violates not-null constraint
--
-- TASK 4.3
-- 1. UNIQUE vs PRIMARY KEY:
-- PRIMARY KEY = UNIQUE + NOT NULL. It uniquely identifies each row.
-- UNIQUE allows NULL values (in PostgreSQL, multiple NULLs are allowed unless specified otherwise).
-- A table can have only one PRIMARY KEY, but many UNIQUE constraints.
--
-- 2. Single-column vs composite PRIMARY KEY:
-- Use single-column when one column alone uniquely identifies a row (e.g., dept_id).
-- Use composite when no single column is unique, but a combination is unique
-- (e.g., student_id + course_id in student_courses).
--
-- 3. Why only one PRIMARY KEY but multiple UNIQUE constraints:
-- PRIMARY KEY defines the main row identity and enforces NOT NULL.
-- UNIQUE constraints enforce uniqueness on alternate candidate keys, but they can allow NULLs
-- and there can be many such constraints per table.



-- TASK 5.1
CREATE TABLE employees_dept (
    emp_id integer PRIMARY KEY,
    emp_name text NOT NULL,
    dept_id integer REFERENCES departments(dept_id),
    hire_date date
);

INSERT INTO employees_dept VALUES
(1, 'Alice', 1, '2024-05-01'),
(2, 'Bob', 2, '2024-06-15');

-- Invalid: non-existent dept_id
-- INSERT INTO employees_dept VALUES (3, 'Charlie', 999, '2024-07-01');
-- ERROR: insert or update on table "employees_dept" violates foreign key constraint
--        Key (dept_id)=(999) is not present in table "departments".

-- TASK 5.2

CREATE TABLE authors (
    author_id integer PRIMARY KEY,
    author_name text NOT NULL,
    country text
);

CREATE TABLE publishers (
    publisher_id integer PRIMARY KEY,
    publisher_name text NOT NULL,
    city text
);

CREATE TABLE books (
    book_id integer PRIMARY KEY,
    title text NOT NULL,
    author_id integer REFERENCES authors(author_id),
    publisher_id integer REFERENCES publishers(publisher_id),
    publication_year integer,
    isbn text UNIQUE
);

INSERT INTO authors VALUES
(1, 'J.K. Rowling', 'UK'),
(2, 'George Orwell', 'UK'),
(3, 'Harper Lee', 'USA');

INSERT INTO publishers VALUES
(1, 'Bloomsbury', 'London'),
(2, 'Penguin', 'London'),
(3, 'HarperCollins', 'New York');

INSERT INTO books VALUES
(1, 'Harry Potter and the Philosopher''s Stone', 1, 1, 1997, '9780747532699'),
(2, '1984', 2, 2, 1949, '9780451524935'),
(3, 'To Kill a Mockingbird', 3, 3, 1960, '9780061120084');

-- TASK 5.3
CREATE TABLE categories (
    category_id integer PRIMARY KEY,
    category_name text NOT NULL
);

CREATE TABLE products_fk (
    product_id integer PRIMARY KEY,
    product_name text NOT NULL,
    category_id integer REFERENCES categories(category_id) ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    order_date date NOT NULL
);

CREATE TABLE order_items (
    item_id integer PRIMARY KEY,
    order_id integer REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id integer REFERENCES products_fk(product_id),
    quantity integer CHECK (quantity > 0)
);

INSERT INTO categories VALUES
(1, 'Electronics'),
(2, 'Books');

INSERT INTO products_fk VALUES
(1, 'Laptop', 1),
(2, 'Novel', 2);

INSERT INTO orders VALUES
(1, '2025-01-15'),
(2, '2025-01-16');

INSERT INTO order_items VALUES
(1, 1, 1, 2),
(2, 1, 2, 1),
(3, 2, 2, 3);

-- Test 1: Delete a category that has products -> should fail with RESTRICT
-- DELETE FROM categories WHERE category_id = 1;
-- ERROR: update or delete on table "categories" violates foreign key constraint
--        on table "products_fk"

-- Test 2: Delete an order -> order_items should be deleted automatically (CASCADE)
DELETE FROM orders WHERE order_id = 1;

SELECT * FROM order_items;
-- Result: only item_id = 3 remains for order_id = 2.
-- Items 1 and 2 were automatically deleted due to ON DELETE CASCADE.



-- TASK 6

DROP TABLE IF EXISTS order_details CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

-- Customers
CREATE TABLE customers (
    customer_id integer PRIMARY KEY,
    name text NOT NULL,
    email text NOT NULL UNIQUE,
    phone text,
    registration_date date NOT NULL
);

-- Products
CREATE TABLE products (
    product_id integer PRIMARY KEY,
    name text NOT NULL,
    description text,
    price numeric NOT NULL CHECK (price >= 0),
    stock_quantity integer NOT NULL CHECK (stock_quantity >= 0)
);

-- Orders
CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    customer_id integer NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    order_date date NOT NULL,
    total_amount numeric NOT NULL CHECK (total_amount >= 0),
    status text NOT NULL CHECK (
        status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')
    )
);

-- Order Details
CREATE TABLE order_details (
    order_detail_id integer PRIMARY KEY,
    order_id integer NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id integer NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT,
    quantity integer NOT NULL CHECK (quantity > 0),
    unit_price numeric NOT NULL CHECK (unit_price >= 0)
);

-- Sample data: 5 records per table

INSERT INTO customers VALUES
(1, 'Alice Johnson', 'alice@example.com', '555-1001', '2025-01-01'),
(2, 'Bob Smith', 'bob@example.com', '555-1002', '2025-01-02'),
(3, 'Carol White', 'carol@example.com', NULL, '2025-01-03'),
(4, 'David Brown', 'david@example.com', '555-1004', '2025-01-04'),
(5, 'Eva Green', 'eva@example.com', '555-1005', '2025-01-05');

INSERT INTO products VALUES
(1, 'Laptop', '15-inch laptop', 999.99, 10),
(2, 'Mouse', 'Wireless mouse', 25.50, 100),
(3, 'Keyboard', 'Mechanical keyboard', 75.00, 50),
(4, 'Monitor', '24-inch monitor', 150.00, 20),
(5, 'Headphones', 'Noise-cancelling headphones', 200.00, 30);

INSERT INTO orders VALUES
(1, 1, '2025-01-10', 1025.49, 'pending'),
(2, 2, '2025-01-11', 25.50, 'processing'),
(3, 3, '2025-01-12', 75.00, 'shipped'),
(4, 4, '2025-01-13', 150.00, 'delivered'),
(5, 5, '2025-01-14', 200.00, 'cancelled');

INSERT INTO order_details VALUES
(1, 1, 1, 1, 999.99),
(2, 1, 2, 1, 25.50),
(3, 2, 2, 1, 25.50),
(4, 3, 3, 1, 75.00),
(5, 4, 4, 1, 150.00);

-- Test queries: show inserted data
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_details;

-- Constraint tests (failed inserts are commented out)

-- Invalid: negative price
-- INSERT INTO products VALUES (6, 'Bad Product', 'Negative price', -10.00, 5);
-- ERROR: violates check constraint "products_price_check"

-- Invalid: invalid order status
-- INSERT INTO orders VALUES (6, 1, '2025-01-15', 100.00, 'unknown');
-- ERROR: violates check constraint "orders_status_check"

-- Invalid: quantity not positive
-- INSERT INTO order_details VALUES (6, 1, 1, 0, 999.99);
-- ERROR: violates check constraint "order_details_quantity_check"

-- Invalid: duplicate customer email
-- INSERT INTO customers VALUES (6, 'Frank', 'alice@example.com', NULL, '2025-01-06');
-- ERROR: violates unique constraint "customers_email_key"

-- Invalid: non-existent customer in orders
-- INSERT INTO orders VALUES (7, 999, '2025-01-16', 50.00, 'pending');
-- ERROR: violates foreign key constraint "orders_customer_id_fkey"

-- Valid: demonstrates nullable phone and valid status
INSERT INTO customers VALUES
(6, 'Frank Black', 'frank@example.com', NULL, '2025-01-06');

-- Optional cascade test:
-- DELETE FROM customers WHERE customer_id = 1;
-- This would delete customer 1, cascade delete their orders,
-- and cascade delete order_details for those orders.