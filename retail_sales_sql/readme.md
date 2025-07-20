
# 🧾 Retail Sales SQL Analysis Project

This project analyzes transaction-level data from a fictional retail store using SQL. It includes data cleaning, exploratory analysis, business-focused insights, and time-based reporting using PostgreSQL.

---

## 📌 Project Overview

The goal of this project is to:
- Clean and validate sales data
- Analyze customer behavior and category trends
- Identify top-performing customers and product categories
- Understand seasonal patterns and hourly sales shifts

---

## 🧩 Dataset Description

**Table: `retail_sales`**

| Column            | Description                          |
|-------------------|--------------------------------------|
| transaction_id    | Unique ID for each transaction       |
| sale_date         | Date of sale                         |
| sale_time         | Time of sale                         |
| customer_id       | Unique customer ID                   |
| gender            | Gender of customer                   |
| age               | Age of customer                      |
| category          | Product category                     |
| quantity          | Quantity purchased                   |
| price_per_unit    | Price per item                       |
| cogs              | Cost of goods sold                   |
| total_sale        | Final sale value (revenue)           |

---

## 🧠 Key SQL Concepts Used

- Data Cleaning with `WHERE`, `IS NULL`
- Aggregation with `SUM()`, `COUNT()`, `AVG()`
- Filtering with `WHERE`, `HAVING`
- Date/Time Functions: `EXTRACT()`, `TO_CHAR()`
- Ranking: `RANK() OVER (PARTITION BY ...)`
- Subqueries and CTEs (`WITH`)
- CASE Statements for conditional grouping

---

## 🔍 Business Questions Answered

1. How many total sales are there?
2. What is the count of unique customers?
3. What are the top-selling categories?
4. What are the most valuable transactions?
5. What time of day generates the most orders?
6. Who are the top 5 highest-paying customers?
7. What month had the highest average sales per year?
8. Which categories are most popular among customers?
9. How does sales distribution differ by gender and category?
10. What is the average age of buyers in the Beauty category?

---

## 📜 Full SQL Code

All SQL queries used in this project are listed below.

```sql
-- View sample data
SELECT * FROM retail_sales
LIMIT 10;

-- Count total sales
SELECT COUNT(*) FROM retail_sales;

-- Check for nulls (Data Cleaning)
SELECT * FROM retail_sales WHERE transactions_id IS NULL;
SELECT * FROM retail_sales WHERE sale_date IS NULL;
SELECT * FROM retail_sales WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL OR
    sale_date IS NULL OR 
    sale_time IS NULL OR
    gender IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;

-- Delete rows with NULLs
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL OR
    sale_date IS NULL OR 
    sale_time IS NULL OR
    gender IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;

-- How many sales do we have?
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- How many unique customers?
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM retail_sales;

-- Distinct categories
SELECT DISTINCT category FROM retail_sales;

-- Q1. All sales on 2022-11-05
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2. Clothing sales > 4 in Nov-2022
SELECT * FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 4;

-- Q3. Total sales by category
SELECT category, SUM(total_sale) AS net_sale, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q4. Average age of customers who bought Beauty products
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5. Transactions with total_sale > 1000
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q6. Number of transactions by gender and category
SELECT category, gender, COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender;

-- Q7. Best selling month in each year (by avg sale)
SELECT year, month, avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) t1
WHERE rank = 1;

-- Q8. Top 5 customers by total sales
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q9. Unique customers per category
SELECT category, COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM retail_sales
GROUP BY category;

-- Q10. Order distribution by shift
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

---

## 🛠️ Tools Used

- PostgreSQL
- pgAdmin

---

## 👤 Author

**Priyanka Das**  
SQL & Data Analytics Portfolio Project  
📫 Email: mailme2priyankadas@gmail.com 


---

## 📄 License

This project is licensed under the MIT License.
