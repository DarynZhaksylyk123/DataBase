
-- PART 1


CREATE TABLE employees (
    emp_id    INT PRIMARY KEY,
    emp_name  VARCHAR(50),
    dept_id   INT,
    salary    DECIMAL(10, 2)
);

CREATE TABLE departments (
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location  VARCHAR(50)
);

CREATE TABLE projects (
    project_id   INT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id      INT,
    budget       DECIMAL(10, 2)
);

INSERT INTO employees (emp_id, emp_name, dept_id, salary) VALUES
(1, 'John Smith',     101, 50000),
(2, 'Jane Doe',       102, 60000),
(3, 'Mike Johnson',   101, 55000),
(4, 'Sarah Williams', 103, 65000),
(5, 'Tom Brown',      NULL, 45000);

INSERT INTO departments (dept_id, dept_name, location) VALUES
(101, 'IT',        'Building A'),
(102, 'HR',        'Building B'),
(103, 'Finance',   'Building C'),
(104, 'Marketing', 'Building D');

INSERT INTO projects (project_id, project_name, dept_id, budget) VALUES
(1, 'Website Redesign',   101, 100000),
(2, 'Employee Training',  102, 50000),
(3, 'Budget Analysis',    103, 75000),
(4, 'Cloud Migration',    101, 150000),
(5, 'AI Research',        NULL, 200000);

-- PART 2

-- Exercise 2.1
SELECT e.emp_name, d.dept_name
FROM employees e CROSS JOIN departments d;
-- Answer: N x M = 5 x 4 = 20 rows.

-- Exercise 2.2
-- a) Comma notation
SELECT e.emp_name, d.dept_name
FROM employees e, departments d;

-- b) INNER JOIN with TRUE condition
SELECT e.emp_name, d.dept_name
FROM employees e INNER JOIN departments d ON TRUE;

-- Exercise 2.3
SELECT e.emp_name, p.project_name
FROM employees e CROSS JOIN projects p
ORDER BY e.emp_name, p.project_name;

-- PART 3: INNER JOIN

-- Exercise 3.1
SELECT e.emp_name, d.dept_name, d.location
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;
-- Answer: 4 rows. Tom Brown has dept_id = NULL, and NULL = anything is
-- never TRUE, so his row has no match and INNER JOIN drops it.

-- Exercise 3.2
SELECT emp_name, dept_name, location
FROM employees
INNER JOIN departments USING (dept_id);
-- Answer: With USING, the join column dept_id appears only once in the
-- output of SELECT * (merged column) and cannot be qualified with a table
-- alias. With ON, SELECT * returns dept_id twice (e.dept_id and d.dept_id).
-- For the explicit column list above the output is identical.

-- Exercise 3.3
SELECT emp_name, dept_name, location
FROM employees
NATURAL INNER JOIN departments;
-- Joins automatically on the only common column name: dept_id.

-- Exercise 3.4
SELECT e.emp_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
INNER JOIN projects p ON d.dept_id = p.dept_id;
-- 6 rows: John and Mike (IT) x 2 IT projects, Jane (HR) x 1, Sarah (Finance) x 1.

-- PART 4

-- Exercise 4.1
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS dept_dept, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;


-- Exercise 4.2
SELECT emp_name, dept_id, dept_name
FROM employees
LEFT JOIN departments USING (dept_id);
-- Answer: Tom Brown appears with emp_dept = NULL, dept_dept = NULL and
-- dept_name = NULL (no matching department).

-- Exercise 4.3
SELECT e.emp_name, e.dept_id
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;

-- Exercise 4.4
SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY employee_count DESC;
-- COUNT(e.emp_id) (not COUNT(*)) so Marketing gets 0 instead of 1.

-- PART 5

-- Exercise 5.1
SELECT e.emp_name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

-- Exercise 5.2
SELECT e.emp_name, d.dept_name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id;

-- Exercise 5.3
SELECT d.dept_name, d.location
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;
-- Result: Marketing (Building D).

-- PART 6: FULL JOIN

-- Exercise 6.1
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS dept_dept, d.dept_name
FROM employees e
FULL JOIN departments d ON e.dept_id = d.dept_id;
-- Answer: NULLs on the LEFT (employee) side: the Marketing row (no employee).
-- NULLs on the RIGHT (department) side: the Tom Brown row (no department).

-- Exercise 6.2
SELECT d.dept_name, p.project_name, p.budget
FROM departments d
FULL JOIN projects p ON d.dept_id = p.dept_id;
-- Marketing appears with NULL project; 'AI Research' appears with NULL department.

-- Exercise 6.3
SELECT
    CASE
        WHEN e.emp_id IS NULL THEN 'Department without employees'
        WHEN d.dept_id IS NULL THEN 'Employee without department'
        ELSE 'Matched'
    END AS record_status,
    e.emp_name,
    d.dept_name
FROM employees e
FULL JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL OR d.dept_id IS NULL;

-- PART 7

-- Exercise 7.1
-- Query 1
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id AND d.location = 'Building A';
-- All 5 employees returned; only IT employees (John, Mike) get a dept_name,
-- the others have dept_name = NULL.

-- Exercise 7.2
-- Query 2
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';
-- Only 2 rows (John, Mike). WHERE runs after the join and removes rows
-- where location is NULL or not 'Building A', which turns the LEFT JOIN
-- into an effective INNER JOIN.

-- Exercise 7.3
-- Query 1 (ON)
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id AND d.location = 'Building A';

-- Query 2 (WHERE)
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';
-- Answer: No difference (both return John and Mike). INNER JOIN only keeps
-- rows that satisfy all conditions, so it does not matter whether the
-- filter is applied during the join (ON) or after it (WHERE). Only outer
-- joins add "unmatched" rows, which is where the position matters.


-- PART 8

-- Exercise 8.1
SELECT
    d.dept_name,
    e.emp_name,
    e.salary,
    p.project_name,
    p.budget
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
LEFT JOIN projects p  ON d.dept_id = p.dept_id
ORDER BY d.dept_name, e.emp_name;

-- Exercise 8.2
ALTER TABLE employees ADD COLUMN manager_id INT;

UPDATE employees SET manager_id = 3    WHERE emp_id = 1;
UPDATE employees SET manager_id = 3    WHERE emp_id = 2;
UPDATE employees SET manager_id = NULL WHERE emp_id = 3;
UPDATE employees SET manager_id = 3    WHERE emp_id = 4;
UPDATE employees SET manager_id = 3    WHERE emp_id = 5;

SELECT
    e.emp_name AS employee,
    m.emp_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;

-- Exercise 8.3
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM departments d
INNER JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 50000;
-- IT (52500), HR (60000), Finance (65000).

-- LAB QUESTIONS answers
-- 1. INNER JOIN returns only rows with a match in both tables. LEFT JOIN
--    returns all rows from the left table, with NULLs for the right side
--    when there is no match.
--
-- 2. CROSS JOIN is useful for generating all combinations: availability
--    matrices (employee x project), calendars (dates x rooms), product
--    variants (sizes x colors), or test data.
--
-- 3. In an inner join, a row survives only if it satisfies all conditions,
--    so ON and WHERE are logically equivalent. In an outer join, ON decides
--    what counts as a match (unmatched preserved rows are still output with
--    NULLs), while WHERE filters the output afterward and removes those
--    NULL-extended rows.
--
-- 4. 5 x 10 = 50.
--
-- 5. NATURAL JOIN automatically joins on ALL columns that have the same name
--    in both tables (equality on each), and outputs each such column once.
--
-- 6. Risks: it silently changes behavior when columns are added or renamed
--    (a new same-named column becomes an extra join condition); it can join
--    on unintended columns (e.g. both tables have 'name' or 'created_at');
--    if there are no common columns it degenerates into a CROSS JOIN; and
--    it makes queries harder to read and maintain.
--
-- 7. SELECT * FROM B RIGHT JOIN A ON A.id = B.id
--    (the preserved table A stays the same; only the order of writing changes)
--
-- 8. Use FULL OUTER JOIN when you need all rows from both tables whether or
--    not they match: reconciling two data sources, finding unmatched records
--    on either side (data-quality checks), or merging datasets.

-- ADDITIONAL CHALLENGES (optional)

-- Challenge 1
SELECT e.emp_name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
UNION
SELECT e.emp_name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

-- Challenge 2
SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IN (
    SELECT dept_id
    FROM projects
    GROUP BY dept_id
    HAVING COUNT(*) > 1
);
-- Result: John Smith and Mike Johnson (IT has 2 projects).

-- Challenge 3: Organizational hierarchy via self-joins
-- (employee -> manager -> manager's manager -> ...)
SELECT
    e.emp_name  AS employee,
    m1.emp_name AS manager,
    m2.emp_name AS managers_manager,
    m3.emp_name AS level_3_manager
FROM employees e
LEFT JOIN employees m1 ON e.manager_id  = m1.emp_id
LEFT JOIN employees m2 ON m1.manager_id = m2.emp_id
LEFT JOIN employees m3 ON m2.manager_id = m3.emp_id
ORDER BY e.emp_name;

-- Challenge 4: All pairs of employees in the same department
SELECT
    e1.emp_name AS employee_1,
    e2.emp_name AS employee_2,
    d.dept_name
FROM employees e1
INNER JOIN employees e2
        ON e1.dept_id = e2.dept_id
       AND e1.emp_id < e2.emp_id
INNER JOIN departments d ON e1.dept_id = d.dept_id;
-- Result: John Smith & Mike Johnson (IT).