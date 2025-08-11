💳 Finance SQL Analysis Project

Welcome to the Finance SQL Analysis Project!
This project explores client spending behavior, card usage, and transaction trends using structured SQL queries. It simulates a financial database that includes client demographics, credit data, and detailed transaction records.

🧩 Project Overview
This project demonstrates SQL skills by performing:

Data cleaning and transformation

Analytical aggregations

Categorization and classification logic

Joins across relational tables

Window functions for rankings and trends



🗃️ Database Tables Used
Table Name	Description
clients	Contains client demographics, financial stats like credit score and income
cards	Stores data about card types, brands, expiration, and client link
transactions	Logs all financial transactions including amount, merchant, and card used

✅ Key SQL Features Demonstrated
🛠️ Data Preprocessing
Renamed people_financials table to clients

Removed errors column from transactions

Converted amount from text ($) to NUMERIC

📊 Core Analytical Queries
Total spending per client

Top 5 largest transactions

Monthly spending trends

Client averages & classification by transaction level

Average credit score by gender

Identify clients with debt exceeding income

Credit score-based credit health labels

🧠 Business Insights
Transactions joined with card brand and client gender

Most common card types in usage

Clients using multiple card brands

Cards expiring in a specific year

Cards issued per client and type

📈 Advanced Analytics
Window functions: RANK(), SUM() OVER, AVG() OVER

Transaction segmentation: High / Medium / Low

Spending behavior flags: Above/Below average

First and last transaction dates per client

Repeat purchases by client-merchant pair

MCC (merchant category code) spending breakdown

🔍 Highlighted Query Samples

sql
-- Label transactions as High / Medium / Low

SELECT id, amount, CASE
amount >= 500 THEN 'High' 
WHEN amount >= 100 THEN 'Medium'
ELSE 'Low'
END AS transaction_level
FROM transactions;

-- Monthly average spend per client

SELECT client_id, DATE_TRUNC('month', date) AS month, AVG(amount)
FROM transactions
GROUP BY client_id, month;

-- Clients with multiple card brands

SELECT client_id, COUNT(DISTINCT card_brand)
FROM cards
GROUP BY client_id
HAVING COUNT(DISTINCT card_brand) > 1;

🛠️ Tech Stack

PostgreSQL

SQL Aggregations

Window Functions

Conditional Logic

Data Cleaning

