
-- CREATE DATABASE
CREATE DATABASE Assets_db;

USE Assets_db;

-- CREATE TABLE: Departments
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

-- INSERT DATA INTO Departments
INSERT INTO departments VALUES
(1, 'IT'),
(2, 'Finance'),
(3, 'HR');

-- CREATE TABLE: Employees
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department_id INT,
    
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);

-- INSERT DATA INTO Employees
INSERT INTO employees VALUES
(101, 'Swathi', 1),
(102, 'Kavitha', 2),
(103, 'Ramya', 2);

-- CREATE TABLE: Assets
CREATE TABLE assets (
    asset_id INT PRIMARY KEY,
    asset_name VARCHAR(100),
    asset_value DECIMAL(10,2),
    status VARCHAR(50),
    assigned_to INT,
    assigned_date DATE,
    last_used_date DATE,

    FOREIGN KEY (assigned_to)
    REFERENCES employees(employee_id)
);

-- INSERT DATA INTO Assets
INSERT INTO assets VALUES
(201, 'Laptop Dell', 65000, 'Assigned', 101, '2026-03-15', '2026-05-25'),

(202, 'Office Chair', 8000, 'Assigned', 102, '2026-04-12', '2026-05-11'),

(203, 'Projector', 45000, 'Maintenance', 103, '2026-01-15', '2025-10-01');

-- CREATE TABLE: Asset Assignments
CREATE TABLE asset_assignments (
    assignment_id INT PRIMARY KEY,
    asset_id INT,
    employee_id INT,
    assigned_date DATE,
    returned_date DATE,

    FOREIGN KEY (asset_id)
    REFERENCES assets(asset_id),

    FOREIGN KEY (employee_id)
    REFERENCES employees(employee_id)
);

-- INSERT DATA INTO Asset Assignments
INSERT INTO asset_assignments VALUES
(1, 201, 101, '2026-03-15', NULL),
(2, 202, 102, '2026-04-12', NULL),
(3, 203, 103, '2026-01-15', NULL);

-- CREATE TABLE: Maintenance
CREATE TABLE maintenance (
    maintenance_id INT PRIMARY KEY,
    asset_id INT,
    maintenance_cost DECIMAL(10,2),
    maintenance_date DATE,
    request_status VARCHAR(50),

    FOREIGN KEY (asset_id)
    REFERENCES assets(asset_id)
);

-- INSERT DATA INTO Maintenance
INSERT INTO maintenance VALUES
(1, 203, 1500, '2026-01-15', 'Completed');

-- CREATE TABLE: Asset Audit
CREATE TABLE asset_audit (
    audit_id INT PRIMARY KEY,
    asset_id INT,
    employee_id INT,
    action_type VARCHAR(50),
    action_date DATE,

    FOREIGN KEY (asset_id)
    REFERENCES assets(asset_id),

    FOREIGN KEY (employee_id)
    REFERENCES employees(employee_id)
);

-- INSERT DATA INTO Asset Audit
INSERT INTO asset_audit VALUES
(1, 201, 101, 'Assigned', '2026-01-10'),
(2, 202, 102, 'Assigned', '2026-02-12');

-- 1. FIND MOST ASSIGNED ASSETS
SELECT
    a.asset_id,
    a.asset_name,
    COUNT(aa.assignment_id) AS total_assignments

FROM assets a

JOIN asset_assignments aa
ON a.asset_id = aa.asset_id

GROUP BY a.asset_id, a.asset_name

ORDER BY total_assignments DESC;

-- 2. EMPLOYEES HOLDING MULTIPLE ASSETS
SELECT
    e.employee_id,
    e.employee_name,
    COUNT(a.asset_id) AS total_assets

FROM employees e

JOIN assets a
ON e.employee_id = a.assigned_to

GROUP BY e.employee_id, e.employee_name

HAVING COUNT(a.asset_id) > 1;

-- 3. MONTHLY MAINTENANCE COST REPORT
SELECT
    YEAR(maintenance_date) AS year,
    MONTH(maintenance_date) AS month,
    SUM(maintenance_cost) AS total_cost

FROM maintenance

GROUP BY YEAR(maintenance_date),
         MONTH(maintenance_date)

ORDER BY year, month;

-- 4. ASSETS NOT USED FOR LAST 6 MONTHS
SELECT
    asset_id,
    asset_name,
    last_used_date

FROM assets

WHERE last_used_date <
      CURDATE() - INTERVAL 6 MONTH;

-- 5. ASSET UTILIZATION PERCENTAGE
SELECT
    COUNT(
        CASE
            WHEN status = 'Assigned'
            THEN 1
        END
    ) * 100.0 / COUNT(*) AS utilization_percentage

FROM assets;

-- 6. DEPARTMENT-WISE ASSET ALLOCATION
SELECT
    d.department_name,
    COUNT(a.asset_id) AS total_assets

FROM departments d

JOIN employees e
ON d.department_id = e.department_id

JOIN assets a
ON e.employee_id = a.assigned_to

GROUP BY d.department_name

ORDER BY total_assets DESC;

-- 7. TOP 5 EXPENSIVE ASSETS
SELECT
    asset_id,
    asset_name,
    asset_value

FROM assets

ORDER BY asset_value DESC

LIMIT 5;

-- 8. ASSETS UNDER MAINTENANCE
SELECT
    a.asset_id,
    a.asset_name,
    m.request_status

FROM assets a

JOIN maintenance m
ON a.asset_id = m.asset_id

WHERE a.status = 'Maintenance'
AND m.request_status = 'Pending';

-- 9. EMPLOYEE ASSET AUDIT REPORT
SELECT
    e.employee_name,
    a.asset_name,
    aa.action_type,
    aa.action_date

FROM asset_audit aa

JOIN employees e
ON aa.employee_id = e.employee_id

JOIN assets a
ON aa.asset_id = a.asset_id

ORDER BY aa.action_date DESC;

-- 10. RANK DEPARTMENTS BY ASSET VALUE
SELECT
    d.department_name,

    SUM(a.asset_value) AS total_asset_value,

    DENSE_RANK() OVER (
        ORDER BY SUM(a.asset_value) DESC
    ) AS department_rank

FROM departments d

JOIN employees e
ON d.department_id = e.department_id

JOIN assets a
ON e.employee_id = a.assigned_to

GROUP BY d.department_name;