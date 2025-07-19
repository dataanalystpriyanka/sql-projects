DROP TABLE IF EXISTS submission_format;

CREATE TABLE submission_format (
    Date DATE,
    Product_ID INT,
    Units_Sold FLOAT
);

--Most Sold Products

SELECT Product_ID, SUM(Units_Sold) AS Total_Sales
FROM train_data
GROUP BY Product_ID
ORDER BY Total_Sales DESC
LIMIT 5;

--Average Sales by Promotion
SELECT Promotion, AVG(Units_Sold) AS Avg_Sales
FROM train_data
GROUP BY Promotion;

--Average Feedback by Product
SELECT Product_ID, AVG(Customer_Feedback_Rating) AS Avg_Rating
FROM train_data
GROUP BY Product_ID
ORDER BY Avg_Rating DESC;

--Does Promotion Increase Sales?
SELECT 
    Promotion, 
    AVG(Units_Sold) AS Avg_Sales
FROM train_data
GROUP BY Promotion;

--Which Products Perform Best Under Promotion?
SELECT Product_ID, AVG(Units_Sold) AS Avg_Sales
FROM train_data
WHERE Promotion = 1
GROUP BY Product_ID
ORDER BY Avg_Sales DESC;

--Which products have improving customer ratings over time?
SELECT Product_ID, 
       DATE_TRUNC('month', Date) AS Month,
       AVG(Customer_Feedback_Rating) AS Avg_Rating
FROM train_data
GROUP BY Product_ID, DATE_TRUNC('month', Date)
ORDER BY Product_ID, Month;

--Find best and worst performing products (top/bottom 5)
-- Best
SELECT Product_ID, AVG(Units_Sold) AS Avg_Sales
FROM train_data
GROUP BY Product_ID
ORDER BY Avg_Sales DESC
LIMIT 5;

-- Worst
SELECT Product_ID, AVG(Units_Sold) AS Avg_Sales
FROM train_data
GROUP BY Product_ID
ORDER BY Avg_Sales ASC
LIMIT 5;

--Which products receive high ratings but low sales?
SELECT Product_ID,
       AVG(Customer_Feedback_Rating) AS Avg_Rating,
       AVG(Units_Sold) AS Avg_Sales
FROM train_data
GROUP BY Product_ID
HAVING AVG(Customer_Feedback_Rating) >= 4.0 AND AVG(Units_Sold) < 5
ORDER BY Avg_Rating DESC;

--Find products with frequent stockouts (Inventory = 0)
SELECT Product_ID, COUNT(*) AS Stockout_Days
FROM train_data
WHERE Inventory_Level = 0
GROUP BY Product_ID
ORDER BY Stockout_Days DESC;

--Compare Train and Test Data Inventory for Same Product + Date
SELECT 
    t.Date,
    t.Product_ID,
    t.Inventory_Level AS Test_Inventory,
    tr.Inventory_Level AS Train_Inventory
FROM test_data t
LEFT JOIN train_data tr
  ON t.Date = tr.Date AND t.Product_ID = tr.Product_ID;

--Average Units Sold for Matching Product + Promotion from Train
SELECT 
    t.Product_ID,
    t.Promotion,
    AVG(tr.Units_Sold) AS Avg_Historical_Sales
FROM test_data t
LEFT JOIN train_data tr
  ON t.Product_ID = tr.Product_ID AND t.Promotion = tr.Promotion
GROUP BY t.Product_ID, t.Promotion;

--Products in Test that Never Appeared in Train
SELECT DISTINCT t.Product_ID
FROM test_data t
LEFT JOIN train_data tr
  ON t.Product_ID = tr.Product_ID
WHERE tr.Product_ID IS NULL;

--Feedback Trends: Test vs Train
SELECT 
    t.Product_ID,
    AVG(t.Customer_Feedback_Rating) AS Test_Feedback,
    AVG(tr.Customer_Feedback_Rating) AS Train_Feedback
FROM test_data t
LEFT JOIN train_data tr
  ON t.Product_ID = tr.Product_ID
GROUP BY t.Product_ID;

--Running Total of Units Sold per Product Over Time
SELECT 
    Product_ID,
    Date,
    Units_Sold,
    SUM(Units_Sold) OVER (PARTITION BY Product_ID ORDER BY Date) AS Running_Total_Sales
FROM train_data
ORDER BY Product_ID, Date;

--Rank Products by Daily Sales
SELECT 
    Date,
    Product_ID,
    Units_Sold,
    RANK() OVER (PARTITION BY Date ORDER BY Units_Sold DESC) AS Sales_Rank
FROM train_data
ORDER BY Date, Sales_Rank;

--Find the First and Last Sale Date for Each Product
SELECT *
FROM (
  SELECT 
      Product_ID,
      Date,
      Units_Sold,
      FIRST_VALUE(Date) OVER (PARTITION BY Product_ID ORDER BY Date) AS First_Sale_Date,
      LAST_VALUE(Date) OVER (PARTITION BY Product_ID ORDER BY Date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_Sale_Date
  FROM train_data
) AS product_sales;

 --Days Since Last Sale for Each Product
 SELECT 
    Product_ID,
    Date,
    Units_Sold,
    Date - LAG(Date) OVER (PARTITION BY Product_ID ORDER BY Date) AS Days_Since_Last_Sale
FROM train_data;

--Rank Products by Feedback Within Each Promotion Status
SELECT 
    Product_ID,
    Promotion,
    Customer_Feedback_Rating,
    RANK() OVER (PARTITION BY Promotion ORDER BY Customer_Feedback_Rating DESC) AS Rating_Rank
FROM train_data;

--Tag Sales as High / Medium / 
SELECT 
    Product_ID,
    Date,
    Units_Sold,
    CASE
        WHEN Units_Sold >= 15 THEN 'High'
        WHEN Units_Sold BETWEEN 5 AND 14 THEN 'Medium'
        ELSE 'Low'
    END AS Sales_Category
FROM train_data;

--Check If Promotion Increased Sales (Based on Average Threshold)
SELECT 
    Product_ID,
    Promotion,
    Units_Sold,
    CASE
        WHEN Promotion = 1 AND Units_Sold > 10 THEN 'Effective'
        WHEN Promotion = 1 THEN 'Ineffective'
        ELSE 'No Promotion'
    END AS Promotion_Result
FROM train_data;

--Predict Sales Buckets for Test Data (Rule-based)
SELECT 
    Product_ID,
    Inventory_Level,
    Promotion,
    Customer_Feedback_Rating,
    CASE
        WHEN Promotion = 1 AND Inventory_Level > 10 THEN 15
        WHEN Promotion = 1 THEN 10
        WHEN Customer_Feedback_Rating >= 4 THEN 12
        WHEN Inventory_Level <= 5 THEN 5
        ELSE 8
    END AS Predicted_Units_Sold
FROM test_data;

