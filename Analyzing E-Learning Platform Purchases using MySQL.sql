-- Create Database
CREATE DATABASE elearning_platform;

-- Use Database
USE elearning_platform;

CREATE TABLE learners (
    learner_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    country VARCHAR(50)
);

-- Create courses table
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2)
);

-- Create purchases table
CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    learner_id INT,
    course_id INT,
    quantity INT,
    purchase_date DATE,
    
    FOREIGN KEY (learner_id) REFERENCES learners(learner_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO learners VALUES
(1, 'Aarav Kumar', 'India'),
(2, 'Sophia Lee', 'USA'),
(3, 'John Smith', 'UK'),
(4, 'Meera Nair', 'India'),
(5, 'David Brown', 'Canada');

INSERT INTO courses VALUES
(101, 'Python for Beginners', 'Programming', 1200.00),
(102, 'Data Analytics with SQL', 'Data Analytics', 1500.00),
(103, 'Digital Marketing Mastery', 'Marketing', 1000.00),
(104, 'Excel for Business', 'Business', 800.00),
(105, 'Machine Learning Basics', 'AI', 2000.00);

INSERT INTO purchases VALUES
(1001, 1, 101, 1, '2026-01-10'),
(1002, 1, 102, 1, '2026-01-15'),
(1003, 2, 103, 2, '2026-01-18'),
(1004, 3, 101, 1, '2026-01-20'),
(1005, 4, 104, 3, '2026-01-25'),
(1006, 2, 102, 1, '2026-01-28'),
(1007, 5, 105, 1, '2026-02-01'),
(1008, 4, 103, 1, '2026-02-05');

-- INNER JOIN
SELECT 
    l.full_name AS learner_name,
    c.course_name,
    c.category,
    p.quantity,
    FORMAT(p.quantity * c.unit_price, 2) AS total_amount,
    p.purchase_date
FROM purchases p
INNER JOIN learners l
    ON p.learner_id = l.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
ORDER BY total_amount DESC;

-- LEFT JOIN
SELECT 
    l.full_name AS learner_name,
    c.course_name,
    c.category,
    p.quantity,
    FORMAT(p.quantity * c.unit_price, 2) AS total_amount,
    p.purchase_date
FROM learners l
LEFT JOIN purchases p
    ON l.learner_id = p.learner_id
LEFT JOIN courses c
    ON p.course_id = c.course_id
ORDER BY learner_name;

-- RIGHT JOIN
SELECT 
    l.full_name AS learner_name,
    c.course_name,
    c.category,
    p.quantity,
    FORMAT(p.quantity * c.unit_price, 2) AS total_amount,
    p.purchase_date
FROM learners l
RIGHT JOIN purchases p
    ON l.learner_id = p.learner_id
RIGHT JOIN courses c
    ON p.course_id = c.course_id
ORDER BY c.course_name;

-- Q1. Total Spending of Each Learner
SELECT 
    l.full_name AS learner_name,
    l.country,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_spent
FROM learners l
INNER JOIN purchases p
    ON l.learner_id = p.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name, l.country
ORDER BY SUM(p.quantity * c.unit_price) DESC;

-- Q2. Top 3 Most Purchased Courses
SELECT 
    c.course_name,
    SUM(p.quantity) AS total_quantity_sold
FROM courses c
INNER JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY c.course_id, c.course_name
ORDER BY total_quantity_sold DESC
LIMIT 3;

-- Q3. Revenue and Unique Learners by Category
SELECT 
    c.category,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_revenue,
    COUNT(DISTINCT p.learner_id) AS unique_learners
FROM courses c
INNER JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY c.category
ORDER BY SUM(p.quantity * c.unit_price) DESC;

-- Q4. Learners Who Purchased from More Than One Category
SELECT 
    l.full_name AS learner_name,
    COUNT(DISTINCT c.category) AS categories_purchased
FROM learners l
INNER JOIN purchases p
    ON l.learner_id = p.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name
HAVING COUNT(DISTINCT c.category) > 1;

-- Q5. Courses Not Purchased at All
SELECT 
    c.course_name,
    c.category
FROM courses c
LEFT JOIN purchases p
    ON c.course_id = p.course_id
WHERE p.purchase_id IS NULL;
