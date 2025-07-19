# 🛍️ MystiqueMart: E-Commerce Sales Analytics with SQL

Welcome to **MystiqueMart**, a fictional e-commerce platform built for advanced SQL data analysis. This project explores sales performance, customer satisfaction, promotional impact, and operational efficiency using pure SQL techniques on structured transactional data.

---

## 📌 Project Overview

This SQL analytics project answers key business questions for a retail company, using **PostgreSQL** as the analysis engine. It showcases your ability to:

- Analyze large-scale transactional datasets
- Use advanced SQL queries and window functions
- Derive business insights from sales, feedback, and promotions
- Build a rule-based predictive system for inventory and sales

---

## 🧩 Data Sources

| Table Name           | Description |
|----------------------|-------------|
| `train_data`         | Historical data including product sales, promotions, feedback, and inventory |
| `test_data`          | Future data used for prediction/evaluation |
| `submission_format`  | Required format for submitting predicted values |

---

## 🔍 Key Business Questions Answered

### 📦 Sales Analysis
- Top 5 best- and worst-selling products
- Running total of units sold per product
- Ranking products daily by sales volume
- Classifying sales into High/Medium/Low categories

### 🎯 Promotion Impact
- Does promotion increase average sales?
- Which products perform best under promotions?
- Tagging promotions as Effective / Ineffective / No Promotion

### ⭐ Customer Feedback
- Highest and lowest-rated products
- Trends in customer feedback over time
- Products with high ratings but poor sales

### 🧰 Inventory & Operations
- Products frequently out of stock (stockouts)
- Days between product sales (gap analysis)
- Inventory comparison between train and test datasets

### 🔮 Predictive Logic
- Rule-based predicted sales for test data using:
  - Promotion status
  - Inventory level
  - Customer feedback rating

---

## 🧠 SQL Techniques Used

- ✅ **Window Functions**: `RANK()`, `LAG()`, `SUM() OVER`, `FIRST_VALUE()`, `LAST_VALUE()`
- ✅ **Date Functions**: `DATE_TRUNC()`, date differences
- ✅ **Aggregates**: `SUM()`, `AVG()`, `COUNT()`
- ✅ **Joins**: `LEFT JOIN`, `INNER JOIN`
- ✅ **Conditional Logic**: `CASE WHEN` for sales and promotion classification
- ✅ **Data Filtering**: `HAVING`, subqueries, derived tables

---

## 💡 Analysis

## 📜 Full List of SQL Queries

```sql
-- Most Sold Products
SELECT Product_ID, SUM(Units_Sold) AS Total_Sales
FROM train_data
GROUP BY Product_ID
ORDER BY Total_Sales DESC
LIMIT 5;

-- Average Sales by Promotion
SELECT Promotion, AVG(Units_Sold) AS Avg_Sales
FROM train_data
GROUP BY Promotion;

-- Average Feedback by Product
SELECT Product_ID, AVG(Customer_Feedback_Rating) AS Avg_Rating
FROM train_data
GROUP BY Product_ID
ORDER BY Avg_Rating DESC;

-- Does Promotion Increase Sales?
SELECT Promotion, AVG(Units_Sold) AS Avg_Sales
FROM train_data
GROUP BY Promotion;

-- Best Performing Products Under Promotion
SELECT Product_ID, AVG(Units_Sold) AS Avg_Sales
FROM train_data
WHERE Promotion = 1
GROUP BY Product_ID
ORDER BY Avg_Sales DESC;

-- Products with Improving Ratings Over Time
SELECT Product_ID, DATE_TRUNC('month', Date) AS Month,
       AVG(Customer_Feedback_Rating) AS Avg_Rating
FROM train_data
GROUP BY Product_ID, DATE_TRUNC('month', Date)
ORDER BY Product_ID, Month;

-- Best Performing Products (Top 5)
SELECT Product_ID, AVG(Units_Sold) AS Avg_Sales
FROM train_data
GROUP BY Product_ID
ORDER BY Avg_Sales DESC
LIMIT 5;

-- Worst Performing Products (Bottom 5)
SELECT Product_ID, AVG(Units_Sold) AS Avg_Sales
FROM train_data
GROUP BY Product_ID
ORDER BY Avg_Sales ASC
LIMIT 5;

-- High Ratings but Low Sales
SELECT Product_ID, AVG(Customer_Feedback_Rating) AS Avg_Rating,
       AVG(Units_Sold) AS Avg_Sales
FROM train_data
GROUP BY Product_ID
HAVING AVG(Customer_Feedback_Rating) >= 4.0 AND AVG(Units_Sold) < 5
ORDER BY Avg_Rating DESC;

-- Products with Frequent Stockouts
SELECT Product_ID, COUNT(*) AS Stockout_Days
FROM train_data
WHERE Inventory_Level = 0
GROUP BY Product_ID
ORDER BY Stockout_Days DESC;

-- Compare Inventory (Train vs Test)
SELECT t.Date, t.Product_ID,
       t.Inventory_Level AS Test_Inventory,
       tr.Inventory_Level AS Train_Inventory
FROM test_data t
LEFT JOIN train_data tr
  ON t.Date = tr.Date AND t.Product_ID = tr.Product_ID;

-- Average Historical Sales for Matching Promotion
SELECT t.Product_ID, t.Promotion,
       AVG(tr.Units_Sold) AS Avg_Historical_Sales
FROM test_data t
LEFT JOIN train_data tr
  ON t.Product_ID = tr.Product_ID AND t.Promotion = tr.Promotion
GROUP BY t.Product_ID, t.Promotion;

-- Products in Test Not Seen in Train
SELECT DISTINCT t.Product_ID
FROM test_data t
LEFT JOIN train_data tr
  ON t.Product_ID = tr.Product_ID
WHERE tr.Product_ID IS NULL;

-- Feedback Trends: Test vs Train
SELECT t.Product_ID,
       AVG(t.Customer_Feedback_Rating) AS Test_Feedback,
       AVG(tr.Customer_Feedback_Rating) AS Train_Feedback
FROM test_data t
LEFT JOIN train_data tr
  ON t.Product_ID = tr.Product_ID
GROUP BY t.Product_ID;

-- Running Total of Sales
SELECT Product_ID, Date, Units_Sold,
       SUM(Units_Sold) OVER (PARTITION BY Product_ID ORDER BY Date) AS Running_Total_Sales
FROM train_data
ORDER BY Product_ID, Date;

-- Rank Products by Daily Sales
SELECT Date, Product_ID, Units_Sold,
       RANK() OVER (PARTITION BY Date ORDER BY Units_Sold DESC) AS Sales_Rank
FROM train_data
ORDER BY Date, Sales_Rank;

-- First and Last Sale Dates
SELECT * FROM (
  SELECT Product_ID, Date, Units_Sold,
         FIRST_VALUE(Date) OVER (PARTITION BY Product_ID ORDER BY Date) AS First_Sale_Date,
         LAST_VALUE(Date) OVER (PARTITION BY Product_ID ORDER BY Date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_Sale_Date
  FROM train_data
) AS product_sales;

-- Days Since Last Sale
SELECT Product_ID, Date, Units_Sold,
       Date - LAG(Date) OVER (PARTITION BY Product_ID ORDER BY Date) AS Days_Since_Last_Sale
FROM train_data;

-- Rank Products by Feedback within Promotion
SELECT Product_ID, Promotion, Customer_Feedback_Rating,
       RANK() OVER (PARTITION BY Promotion ORDER BY Customer_Feedback_Rating DESC) AS Rating_Rank
FROM train_data;

-- Categorize Sales
SELECT Product_ID, Date, Units_Sold,
       CASE
           WHEN Units_Sold >= 15 THEN 'High'
           WHEN Units_Sold BETWEEN 5 AND 14 THEN 'Medium'
           ELSE 'Low'
       END AS Sales_Category
FROM train_data;

-- Check Promotion Effectiveness
SELECT Product_ID, Promotion, Units_Sold,
       CASE
           WHEN Promotion = 1 AND Units_Sold > 10 THEN 'Effective'
           WHEN Promotion = 1 THEN 'Ineffective'
           ELSE 'No Promotion'
       END AS Promotion_Result
FROM train_data;

-- Rule-Based Sales Prediction for Test Data
SELECT Product_ID, Inventory_Level, Promotion, Customer_Feedback_Rating,
       CASE
           WHEN Promotion = 1 AND Inventory_Level > 10 THEN 15
           WHEN Promotion = 1 THEN 10
           WHEN Customer_Feedback_Rating >= 4 THEN 12
           WHEN Inventory_Level <= 5 THEN 5
           ELSE 8
       END AS Predicted_Units_Sold
FROM test_data;
