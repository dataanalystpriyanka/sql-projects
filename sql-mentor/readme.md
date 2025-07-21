
# 📊 SQL Analytics Project

Welcome to this repository!  
This project showcases a portfolio of SQL queries developed to analyze user submissions and generate actionable insights around engagement, performance, and quality. All queries are written for clarity, reuse, and extensibility.

## 🗃️ Table: user_submissions

| Column Name   | Type      | Description                                                  |
|---------------|-----------|--------------------------------------------------------------|
| id            | INTEGER   | Unique identifier for each submission                        |
| user_id       | INTEGER   | Unique identifier for each user                              |
| question_id   | INTEGER   | Unique identifier for each attempted question                |
| submitted_at  | TIMESTAMP | Date and time when the submission was made                   |
| username      | VARCHAR   | Name of the user who made the submission                     |
| points        | INTEGER   | Points awarded (positive for correct, negative for incorrect)|

## 🛠️ Analytics Queries

### 1. List All Users and Their Stats  
Shows each distinct user's total submissions and points earned.
```sql
SELECT DISTINCT username, COUNT(*) AS total_submission, SUM(points) AS points_earned
FROM user_submissions
GROUP BY username
ORDER BY total_submission DESC;
```

### 2. Daily Average Points of Each User  
Calculates the average points per user per day.
```sql
SELECT TO_CHAR(submitted_at, 'dd-mm') AS day, username, AVG(points) AS avg_points
FROM user_submissions
GROUP BY TO_CHAR(submitted_at, 'dd-mm'), username;
```

### 3. Top 3 Daily Positive Submitters  
Finds the top 3 users with the most correct (positive points) submissions for each day.
```sql
WITH daily_submissions AS (
    SELECT TO_CHAR(submitted_at, 'dd-mm') AS daily, username,
        SUM(CASE WHEN points > 0 THEN 1 ELSE 0 END) AS correct_submission
    FROM user_submissions
    GROUP BY TO_CHAR(submitted_at, 'dd-mm'), username
),
users_rank AS (
    SELECT daily, username, correct_submission,
        DENSE_RANK() OVER(PARTITION BY daily ORDER BY correct_submission DESC) AS rank
    FROM daily_submissions
)
SELECT daily, username, correct_submission
FROM users_rank
WHERE rank <= 3;
```

### 4. Top 5 Users with Most Incorrect Submissions  
Identifies users who made the most mistakes (negative points).
```sql
SELECT username,
    SUM(CASE WHEN points < 0 THEN 1 ELSE 0 END) AS incorrect_submission
FROM user_submissions
GROUP BY username
ORDER BY incorrect_submission DESC
LIMIT 5;
```

### 5. Weekly Top 10 Performers  
Finds the 10 users with the highest total points each week.
```sql
SELECT *
FROM (
    SELECT
        EXTRACT(week FROM submitted_at) AS week, username,
        SUM(points) AS total_points_earned,
        DENSE_RANK() OVER(PARTITION BY EXTRACT(week FROM submitted_at)
            ORDER BY SUM(points) DESC) AS rank
    FROM user_submissions
    GROUP BY EXTRACT(week FROM submitted_at), username
    ORDER BY week, total_points_earned DESC
)
WHERE rank <= 10;
```

## ▶️ How to Use

- Confirm the existence and structure of the `user_submissions` table as detailed above.
- Copy and run any query in your SQL execution environment.
- Adjust date and time formatting to suit your SQL dialect if necessary.
- Explore the analytics for dashboards, reports, or direct insights.

## 💡 Use Cases

- **Leaderboards**: Encourage competition by surfacing daily/weekly top performers.
- **User Analytics**: Track engagement and submission trends over time.
- **Quality Assurance**: Identify users who consistently make mistakes for targeted feedback.
- **Actionable Product Insights**: Make informed decisions based on real user activity.


## 📫 Contact

- Email: mailme2priyankadas@gmail.com
- LinkedIn: [Your LinkedIn Profile]  
- GitHub: [Your GitHub Handle]  

