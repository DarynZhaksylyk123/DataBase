-- TASK 1

CREATE DATABASE advanced_lab;

CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    budget INTEGER,
    manager_id INTEGER
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(100) DEFAULT 'Unassigned',
    salary INTEGER DEFAULT 0,
    hire_date DATE,
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id INTEGER REFERENCES departments(dept_id),
    start_date DATE,
    end_date DATE,
    budget INTEGER
);

-- TASK 2

INSERT INTO employees (first_name, last_name, department)
VALUES
    ('John', 'Snow', 'King');

-- TASK 3

INSERT INTO employees (first_name, last_name, department, salary, status)
VALUES ('Walter', 'White', 'Chemistry', DEFAULT, DEFAULT);

-- TASK 4

INSERT INTO departments (dept_name, budget, manager_id)
VALUES
    ('IT', 100000, 1),
    ('Sales', 80000, 2),
    ('HR', 50000, 3);

-- TASK 5

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Ilon', 'Mask', 'IT', 50000 * 1.1, CURRENT_DATE);

-- TASK 6
CREATE TEMP TABLE temp_employees AS
SELECT * FROM employees
WHERE department = 'IT';

-- TASK 7

UPDATE employees
SET salary = salary * 1.10;

-- TASK 8

UPDATE employees
SET status = 'Senior'
WHERE salary > 60000
  AND hire_date < '2020-01-01';

-- TASK 9

UPDATE employees
SET department = CASE
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
    ELSE 'Junior'
END;

-- TASK 10

UPDATE employees
SET department = DEFAULT
WHERE status = 'Inactive';

-- TASK 11

UPDATE departments d
SET budget = (
    SELECT AVG(e.salary) * 1.20
    FROM employees e
    WHERE e.department = d.dept_name
)
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department = d.dept_name
);

-- TASK 12

UPDATE employees
SET salary = salary * 1.15,
    status = 'Promoted'
WHERE department = 'Sales';

-- TASK 13

DELETE FROM employees
WHERE status = 'Terminated';

-- TASK 14

DELETE FROM employees
WHERE salary < 40000
  AND hire_date > '2023-01-01'
  AND department IS NULL;

-- TASK 15

DELETE FROM departments
WHERE dept_name NOT IN (
    SELECT DISTINCT department
    FROM employees
    WHERE department IS NOT NULL
);

-- TASK 16

DELETE FROM projects
WHERE end_date < '2023-01-01'
RETURNING *;

-- TASK 17

INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
VALUES ('NULL', 'Тестов', NULL, NULL, NULL, 'Active');

-- TASK 18

UPDATE employees
SET department = 'Unassigned'
WHERE department IS NULL;

-- TASK 19

DELETE FROM employees
WHERE salary IS NULL
   OR department IS NULL;

-- TASK 20

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('New', 'Employee', 'IT', 70000, CURRENT_DATE)
RETURNING emp_id, first_name || ' ' || last_name AS full_name;

-- TASK 21

WITH old_salaries AS (
    SELECT emp_id, salary AS old_salary
    FROM employees
    WHERE department = 'IT'
)
UPDATE employees e
SET salary = salary + 5000
FROM old_salaries o
WHERE e.emp_id = o.emp_id
RETURNING e.emp_id, o.old_salary, e.salary AS new_salary;

-- TASK 22

DELETE FROM employees
WHERE hire_date < '2020-01-01'
RETURNING *;

-- TASK 23

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
SELECT 'Ilon', 'Mask', 'IT', 55000, CURRENT_DATE
WHERE NOT EXISTS (
    SELECT 1
    FROM employees
    WHERE first_name = 'Ilon'
      AND last_name = 'Mask'
);

-- TASK 24

UPDATE employees e
SET salary = salary * CASE
    WHEN (SELECT d.budget FROM departments d WHERE d.dept_name = e.department) > 100000
        THEN 1.10
    ELSE 1.05
END;

-- TASK 25

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES
    ('A', 'A', 'Bulk', 50000, CURRENT_DATE),
    ('B', 'B', 'Bulk', 51000, CURRENT_DATE),
    ('C', 'C', 'Bulk', 52000, CURRENT_DATE),
    ('D', 'D', 'Bulk', 53000, CURRENT_DATE),
    ('E', 'E', 'Bulk', 54000, CURRENT_DATE);

UPDATE employees
SET salary = salary * 1.10
WHERE department = 'Bulk';

-- TASK 26

CREATE TABLE employee_archive (LIKE employees INCLUDING ALL);

INSERT INTO employee_archive
SELECT * FROM employees
WHERE status = 'Inactive';

DELETE FROM employees
WHERE status = 'Inactive';

-- TASK 27

UPDATE projects p
SET end_date = end_date + INTERVAL '30 days'
WHERE p.budget > 50000
  AND (
      SELECT COUNT(*)
      FROM employees e
      JOIN departments d ON e.department = d.dept_name
      WHERE d.dept_id = p.dept_id
  ) > 3;