-- SQL Retail Sales Analysis - Portfolio Project
-- Database: PostgreSQL

-- 1. DATABASE SCHEMA SETUP
-- Creating the core table to store retail transaction data
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
    transactions INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- 2. INITIAL DATA INSPECTION
-- Previewing the first 10 rows to verify successful import
SELECT * FROM retail_sales LIMIT 10;

-- Checking the total record count
SELECT COUNT(*) FROM retail_sales;

-- 3. DATA CLEANING
-- Identifying and removing records with NULL values across key columns 
-- to ensure data integrity for analysis.
DELETE FROM retail_sales 
WHERE 
    transactions IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- 4. DATA EXPLORATION (EDA)

-- Total transaction volume
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- Total unique customer base
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;

-- 5. DATA ANALYSIS & BUSINESS KEY PROBLEMS

-- Q1: Retrieve all columns for sales made on a specific date ('2022-11-05')
SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05';

-- Q2: Find high-volume 'Clothing' transactions (Qty > 10) in November 2022
SELECT * FROM retail_sales 
WHERE category = 'Clothing' 
  AND quantity > 10 
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- Q3: Calculate the total cumulative sales per product category
SELECT category, SUM(total_sale) AS total_sales 
FROM retail_sales 
GROUP BY category;

-- Q4: Determine the average age of customers shopping in the 'Beauty' category
SELECT ROUND(AVG(age), 2) AS average_age 
FROM retail_sales 
WHERE category = 'Beauty';

-- Q5: Filter all transactions where the total sale value exceeds 1000
SELECT * FROM retail_sales 
WHERE total_sale > 1000;

-- Q6: Analyze transaction counts by Gender and Category
SELECT gender, category, COUNT(transactions) AS total_transactions 
FROM retail_sales
GROUP BY gender, category
ORDER BY 1, 2;

-- Q7: Calculate average monthly sales and identify top-performing months
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year, 
    EXTRACT(MONTH FROM sale_date) AS month, 
    AVG(total_sale) AS average_sale_per_month 
FROM retail_sales 
GROUP BY 1, 2 
ORDER BY year ASC, average_sale_per_month DESC;

-- Q8: Identify the Top 5 Customers based on lifetime total spend
SELECT customer_id, SUM(total_sale) AS total_spent 
FROM retail_sales 
GROUP BY customer_id 
ORDER BY total_spent DESC 
LIMIT 5;

-- Q9: Count unique customers interacting with each category
SELECT category, COUNT(DISTINCT customer_id) AS unique_customer_count 
FROM retail_sales 
GROUP BY category;

-- Q10: Sales Distribution by Shift (Morning, Afternoon, Evening)
-- Classifying orders into time-based shifts to understand peak periods
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening' 
    END AS shift,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY shift;

-- END OF PROJECT