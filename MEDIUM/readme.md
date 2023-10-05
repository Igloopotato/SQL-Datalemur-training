# DataLemur Analysis

This repository contains my answers to a set of medium SQL-related questions in [DataLemur](https://datalemur.com/questions?category=SQL&difficulty=Medium), where I have answered various questions using the provided dataset.

## Table of Contents

- [Introduction](#introduction)
- [Questions and Answers](#questions-and-answers)
  - [Question 1: User's Third Transaction](https://github.com/marswanttobeanalyst/SQL-Datalemur-training/tree/main/MEDIUM#1-users-third-transaction)
  - [Question 2: Data Science Skills](https://github.com/marswanttobeanalyst/SQL-Datalemur-training/tree/main/MEDIUM#2-sending-vs-opening-snaps)
  - [Question 3: Tweets' Rolling Averages](https://github.com/marswanttobeanalyst/SQL-Datalemur-training/tree/main/MEDIUM#3-tweets-rolling-averages)
  - [Question 4: Unfinished Parts](https://github.com/marswanttobeanalyst/SQL-Datalemur-training/tree/main/MEDIUM#4-highest-grossing-items)
  - 
- [Conclusion](#conclusion)
 
  
## Introduction

In this repository, I have provided answers, some key note if needed to and also a key take away that you can check on to a series of medium SQL-related questions. These questions cover fundamental SQL concepts and operations.

## Questions And Answers

### [1. User's Third Transaction](https://datalemur.com/questions/sql-third-transaction)
Assume you are given the table below on Uber transactions made by users. Write a query to obtain the third transaction of every user. Output the user id, spend and transaction date.

**transactions:**
| user_id | spend  | transaction_date     |
| ------- | ------ | -------------------- |
| 111     | 100.50 | 01/08/2022 12:00:00 |
| 111     | 55.00  | 01/10/2022 12:00:00 |
| 121     | 36.00  | 01/18/2022 12:00:00 |
| 145     | 24.99  | 01/26/2022 12:00:00 |
| 111     | 89.60  | 02/05/2022 12:00:00 |
| 145     | 45.30  | 02/28/2022 12:00:00 |
| 121     | 22.20  | 04/01/2022 12:00:00 |
| 121     | 67.90  | 04/03/2022 12:00:00 |
| 263     | 156.00 | 04/11/2022 12:00:00 |
| 230     | 78.30  | 06/14/2022 12:00:00 |
| 263     | 68.12  | 07/11/2022 12:00:00 |
| 263     | 100.00 | 07/12/2022 12:00:00 |


ANSWER:
```sql
WITH ranked_transaction AS
  (
   SELECT 
    user_id, spend, transaction_date, 
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS rn_transaction
   FROM transactions
  )

SELECT user_id, spend, transaction_date FROM ranked_transaction
WHERE rn_transaction = 3
GROUP BY user_id, spend, transaction_date
ORDER BY user_id;
```

| user_id | spend  | transaction_date     |
| ------- | ------ | -------------------- |
| 111     | 89.60  | 02/05/2022 12:00:00 |
| 121     | 67.90  | 04/03/2022 12:00:00 |
| 263     | 100.00 | 07/12/2022 12:00:00 |

### [2. Sending vs. Opening Snaps](https://datalemur.com/questions/time-spent-snaps)
Assume you're given tables with information on Snapchat users, including their ages and time spent sending and opening snaps.
Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these activities grouped by age group. Round the percentage to 2 decimal places in the output.

Notes:
Calculate the following percentages:
+ Time spent sending / (Time spent sending + Time spent opening)
+ Time spent opening / (Time spent sending + Time spent opening)
+ To avoid integer division in percentages, multiply by 100.0 and not 100.

**activities:**
| activity_id | user_id | activity_type | time_spent | activity_date          |
| ----------- | ------- | ------------- | ---------- | ---------------------- |
| 7274        | 123     | open          | 4.50       | 06/22/2022 12:00:00    |
| 2425        | 123     | send          | 3.50       | 06/22/2022 12:00:00    |
| 1413        | 456     | send          | 5.67       | 06/23/2022 12:00:00    |
| 2536        | 456     | open          | 3.00       | 06/25/2022 12:00:00    |
| 8564        | 456     | send          | 8.24       | 06/26/2022 12:00:00    |
| 5235        | 789     | send          | 6.24       | 06/28/2022 12:00:00    |
| 4251        | 123     | open          | 1.25       | 07/01/2022 12:00:00    |
| 1414        | 789     | chat          | 11.00      | 06/25/2022 12:00:00    |
| 1314        | 123     | chat          | 3.15       | 06/26/2022 12:00:00    |
| 1435        | 789     | open          | 5.25       | 07/02/2022 12:00:00    |


**age_breakdown:**
| user_id | age_bucket |
| ------- | ---------- |
| 123     | 31-35      |
| 456     | 26-30      |
| 789     | 21-25      |


ANSWER:
```sql
WITH activities_cte AS
 (
  SELECT 
   activities.user_id, age_bucket,
   SUM(time_spent) FILTER(WHERE activity_type = 'open') AS total_time_open, 
   SUM(time_spent) FILTER(WHERE activity_type = 'send') AS total_time_send 
  FROM activities
  INNER JOIN age_breakdown 
   ON activities.user_id = age_breakdown.user_id
  GROUP BY activities.user_id, age_bucket
 )

SELECT 
  age_bucket, 
  ROUND((total_time_send / (total_time_send + total_time_open) )*100.0,2) AS rate_time_send,
  ROUND((total_time_open / (total_time_send + total_time_open) )*100.0,2) AS rate_time_open
FROM activities_cte
ORDER BY age_bucket;
```

| age_bucket | rate_time_send | rate_time_open |
| ---------- | -------------- | -------------- |
| 21-25      | 54.31          | 45.69          |
| 26-30      | 82.26          | 17.74          |
| 31-35      | 37.84          | 62.16          |


### [3. Tweets' Rolling Averages](https://datalemur.com/questions/rolling-average-tweets)
Given a table of tweet data over a specified time period, calculate the 3-day rolling average of tweets for each user. Output the user ID, tweet date, and rolling averages rounded to 2 decimal places.

Notes:
A rolling average, also known as a moving average or running mean is a time-series technique that examines trends in data over a specified period of time.
In this case, we want to determine how the tweet count for each user changes over a 3-day period.

**tweets:**
| user_id | tweet_date          | tweet_count |
| ------- | ------------------- | ----------- |
| 111     | 06/01/2022 00:00:00 | 2           |
| 111     | 06/02/2022 00:00:00 | 1           |
| 111     | 06/03/2022 00:00:00 | 3           |
| 111     | 06/04/2022 00:00:00 | 4           |
| 111     | 06/05/2022 00:00:00 | 5           |
| 111     | 06/06/2022 00:00:00 | 4           |
| 111     | 06/07/2022 00:00:00 | 6           |
| 199     | 06/01/2022 00:00:00 | 7           |
| 199     | 06/02/2022 00:00:00 | 5           |
| 199     | 06/03/2022 00:00:00 | 9           |
| 199     | 06/04/2022 00:00:00 | 1           |
| 199     | 06/05/2022 00:00:00 | 8           |
| 199     | 06/06/2022 00:00:00 | 2           |
| 199     | 06/07/2022 00:00:00 | 2           |
| 254     | 06/01/2022 00:00:00 | 1           |
| 254     | 06/02/2022 00:00:00 | 1           |
| 254     | 06/03/2022 00:00:00 | 2           |
| 254     | 06/04/2022 00:00:00 | 1           |
| 254     | 06/05/2022 00:00:00 | 3           |
| 254     | 06/06/2022 00:00:00 | 1           |
| 254     | 06/07/2022 00:00:00 | 3           |


ANSWER:
```sql
SELECT 
  user_id, tweet_date, 
  ROUND(
        AVG(tweet_count) 
        OVER (PARTITION BY(user_id) 
        ORDER BY tweet_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2
       ) AS avg_new
FROM tweets;
```

| user_id | tweet_date          | avg_new |
| ------- | ------------------- | ------- |
| 111     | 06/01/2022 00:00:00 | 2.00    |
| 111     | 06/02/2022 00:00:00 | 1.50    |
| 111     | 06/03/2022 00:00:00 | 2.00    |
| 111     | 06/04/2022 00:00:00 | 2.67    |
| 111     | 06/05/2022 00:00:00 | 4.00    |
| 111     | 06/06/2022 00:00:00 | 4.33    |
| 111     | 06/07/2022 00:00:00 | 5.00    |
| 199     | 06/01/2022 00:00:00 | 7.00    |
| 199     | 06/02/2022 00:00:00 | 6.00    |
| 199     | 06/03/2022 00:00:00 | 7.00    |
| 199     | 06/04/2022 00:00:00 | 5.00    |
| 199     | 06/05/2022 00:00:00 | 6.00    |
| 199     | 06/06/2022 00:00:00 | 3.67    |
| 199     | 06/07/2022 00:00:00 | 4.00    |
| 254     | 06/01/2022 00:00:00 | 1.00    |
| 254     | 06/02/2022 00:00:00 | 1.00    |
| 254     | 06/03/2022 00:00:00 | 1.33    |
| 254     | 06/04/2022 00:00:00 | 1.33    |
| 254     | 06/05/2022 00:00:00 | 2.00    |
| 254     | 06/06/2022 00:00:00 | 1.67    |
| 254     | 06/07/2022 00:00:00 | 2.33    |

### [4. Highest-Grossing Items](https://datalemur.com/questions/sql-highest-grossing) 
Assume you're given a table containing data on Amazon customers and their spending on products in different category, write a query to identify the top two highest-grossing products within each category in the year 2022. The output should include the category, product, and total spend.

**product_spend:**
| category    | product               | user_id | spend  | transaction_date     |
| ----------- | ---------------------- | ------- | ------ | -------------------- |
| appliance   | washing machine       | 123     | 219.80 | 03/02/2022 11:00:00 |
| electronics | vacuum                | 178     | 152.00 | 04/05/2022 10:00:00 |
| electronics | wireless headset       | 156     | 249.90 | 07/08/2022 10:00:00 |
| electronics | vacuum                | 145     | 189.00 | 07/15/2022 10:00:00 |
| electronics | computer mouse        | 195     | 45.00  | 07/01/2022 11:00:00 |
| appliance   | refrigerator          | 165     | 246.00 | 12/26/2021 12:00:00 |
| appliance   | refrigerator          | 123     | 299.99 | 03/02/2022 11:00:00 |
| appliance   | washing machine       | 123     | 220.00 | 07/27/2022 04:00:00 |
| electronics | vacuum                | 156     | 145.66 | 08/10/2022 04:00:00 |
| electronics | wireless headset       | 145     | 198.00 | 08/04/2022 04:00:00 |
| electronics | wireless headset       | 215     | 19.99  | 09/03/2022 16:00:00 |
| appliance   | microwave             | 169     | 49.99  | 08/28/2022 16:00:00 |
| appliance   | microwave             | 101     | 34.49  | 03/01/2023 17:00:00 |
| electronics | 3.5mm headphone jack  | 101     | 7.99   | 10/07/2022 16:00:00 |
| appliance   | microwave             | 101     | 64.95  | 07/08/2023 16:00:00 |

ANSWER:
```sql
WITH product_cte AS 
  (
   SELECT 
    category, product, 
    SUM(spend) AS total_spend,
    DENSE_RANK() OVER (PARTITION BY category ORDER BY SUM(spend) DESC) AS rank
   FROM product_spend
   WHERE transaction_date BETWEEN '01/01/2022'  AND '12/31/2022'
   GROUP BY category, product
   ORDER BY category, total_spend DESC
  )
  
SELECT category, product, total_spend FROM product_cte
WHERE rank <= 2
```

| category    | product               | total_spend |
| ----------- | ---------------------- | ----------- |
| appliance   | washing machine       | 439.80      |
| appliance   | refrigerator          | 299.99      |
| electronics | vacuum                | 486.66      |
| electronics | wireless headset       | 467.89      |

## Conclusion
In conclusion, tackling these medium SQL problems has solidified my understanding of fundamental SQL concepts, honed my problem-solving skills, and boosted my confidence in working with databases. I've learned the importance of efficient data retrieval, adaptability to different SQL dialects, and the value of continuous practice in mastering SQL. These skills are essential for data analysis and management, and I'm well-prepared to tackle more complex SQL challenges in the future.
