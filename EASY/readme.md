# DataLemur Analysis

This repository contains my answers to a set of easy SQL-related questions in [DataLemur](https://datalemur.com/), where I have answered various questions using the provided dataset.

## Table of Contents

- [Introduction](#introduction)
- [Questions and Answers](#questions-and-answers)
  - [Question 1: Page With No Likes](###-1.-Page-With-No-Likes])
  - [Question 2: Another SQL Question](#question-2-another-sql-question)
  - [Question 3: Yet Another Question](#question-3-yet-another-question)
  - [Question 11: Average Review Ratings](https://github.com/marswanttobeanalyst/SQL-Datalemur-training/tree/main/EASY#11-average-review-ratings)
- [Conclusion](#conclusion)
- [License](#license)

## Introduction

In this repository, I have provided answers to a series of easy SQL-related questions. These questions cover fundamental SQL concepts and operations.

## Questions And Answers

### [1. Page With No Likes](https://datalemur.com/questions/sql-page-with-no-likes)

Assume you're given two tables containing data about Facebook Pages and their respective likes (as in "Like a Facebook Page").
Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in ascending order based on the page IDs.

  **pages Example Input:**
| page_id | page_name           |
| ------- | ------------------- |
| 20001   | SQL Solutions       |
| 20045   | Brain Exercises     |
| 20701   | Tips for Data Analysts |
 
  **page_likes Example Input:**
| user_id | page_id | liked_date          |
| ------- | ------- | ------------------- |
| 111     | 20001   | 04/08/2022 00:00:00 |
| 121     | 20045   | 03/12/2022 00:00:00 |
| 156     | 20001   | 07/25/2022 00:00:00 |


ANSWER:
```sql
SELECT pages.page_id FROM pages 
LEFT OUTER JOIN page_likes ON page_likes.page_id = pages.page_id
 WHERE Liked_date IS NULL
ORDER BY pages.page_id;
```

| page_id |
| ------- |
| 20701   |
| 32728   |


### [2. Data Science Skills](https://datalemur.com/questions/matching-skills)

Given a table of candidates and their skills, you're tasked with finding the candidates best suited for an open Data Science job. You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.
Write a query to list the candidates who possess all of the required skills for the job. Sort the output by candidate ID in ascending order.

Assumption:
There are no duplicates in the candidates table.


**candidates Example Input:**
| candidate_id | skill       |
| ------------ | ----------- |
| 123          | Python      |
| 123          | Tableau     |
| 123          | PostgreSQL  |
| 234          | R           |
| 234          | PowerBI     |
| 234          | SQL Server  |
| 345          | Python      |
| 345          | Tableau     |


ANSWER:
```sql
SELECT candidate_id FROM candidates
WHERE skill IN ('Python','PostgreSQL','Tableau')
GROUP BY candidate_id
HAVING COUNT(skill) = 3
ORDER BY candidate_id ASC;
```

| candidate_id |
| ------------ |
| 123          |
| 147          |

### [3. Histogram of Tweets](https://datalemur.com/questions/sql-histogram-tweets)

Assume you're given a table Twitter tweet data, write a query to obtain a histogram of tweets posted per user in 2022. Output the tweet count per user as the bucket and the number of Twitter users who fall into that bucket.
In other words, group the users by the number of tweets they posted in 2022 and count the number of users in each group.

**tweets Example Input:**
| tweet_id | user_id | msg                                                  | tweet_date          |
|----------|---------|------------------------------------------------------|---------------------|
| 214252   | 111     | Am considering taking Tesla private at $420. Funding secured. | 12/30/2021 00:00:00 |
| 739252   | 111     | Despite the constant negative press covfefe         | 01/01/2022 00:00:00 |
| 846402   | 111     | Following @NickSinghTech on Twitter changed my life!  | 02/14/2022 00:00:00 |
| 241425   | 254     | If the salary is so competitive why won’t you tell me what it is? | 03/01/2022 00:00:00 |
| 231574   | 148     | I no longer have a manager. I can't be managed      | 03/23/2022 00:00:00 |


ANSWER:
```sql
SELECT 
  tweet_bucket, 
  COUNT(user_id) AS user_num 
FROM ( 
  SELECT 
  user_id, COUNT(msg) AS tweet_bucket FROM  tweets 
  WHERE tweet_date BETWEEN '01/01/2022'  AND '12/31/2022'
  GROUP BY user_id 
      ) 
  AS Total_tweet
GROUP BY total_tweet.tweet_bucket;
```

| tweet_bucket | user_num |
|--------------|----------|
| 1            | 2        |
| 2            | 1        |

### [4. Unfinished Parts](https://datalemur.com/questions/tesla-unfinished-parts)

Tesla is investigating production bottlenecks and they need your help to extract the relevant data. Write a query to determine which parts have begun the assembly process but are not yet finished.

Assumptions:
parts_assembly table contains all parts currently in production, each at varying stages of the assembly process.
An unfinished part is one that lacks a finish_date.

**tweets Example Input:**
| part    | finish_date         | assembly_step |
| ------- | ------------------- | ------------- |
| battery | 01/22/2022 00:00:00 | 1             |
| battery | 02/22/2022 00:00:00 | 2             |
| battery | 03/22/2022 00:00:00 | 3             |
| bumper  | 01/22/2022 00:00:00 | 1             |
| bumper  | 02/22/2022 00:00:00 | 2             |
| bumper  |                     | 3             |
| bumper  |                     | 4             |


ANSWER:
```sql
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL;
```

| part   | assembly_step |
| ------ | ------------- |
| bumper | 3             |
| bumper | 4             |
| engine | 5             |

### [5. Laptop vs. Mobile Viewership](https://datalemur.com/questions/laptop-mobile-viewership)

Assume you're given the table on user viewership categorised by device type where the three types are laptop, tablet, and phone.
Write a query that calculates the total viewership for laptops and mobile devices where mobile is defined as the sum of tablet and phone viewership. Output the total viewership for laptops as laptop_reviews and the total viewership for mobile devices as mobile_views.

**viewership Example Input:**
| user_id | device_type | view_time          |
| ------- | ----------- | ------------------ |
| 123     | tablet      | 01/02/2022 00:00:00 |
| 125     | laptop      | 01/07/2022 00:00:00 |
| 128     | laptop      | 02/09/2022 00:00:00 |
| 129     | phone       | 02/09/2022 00:00:00 |
| 145     | tablet      | 02/24/2022 00:00:00 |

ANSWER:
```sql
SELECT
COUNT(*) FILTER (WHERE device_type = 'laptop') AS laptop_views,
COUNT(*) FILTER (WHERE device_type IN ('tablet', 'phone')) AS mobile_views
FROM Viewership;


----OTHER METHOD BUT HARDER----
ALTER TABLE Viewership
ADD new_device_type TEXT;

UPDATE Viewership
SET new_device_type =
  CASE
    WHEN device_type = 'phone' THEN 'mobile'
    WHEN device_type = 'tablet' THEN 'mobile'
    ELSE device_type
  END;

SELECT 
  SUM(CASE WHEN new_device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views,
  SUM(CASE WHEN new_device_type = 'mobile' THEN 1 ELSE 0 END) AS mobile_views
FROM Viewership;
```

| laptop_views | mobile_views |
| ------------ | ------------ |
| 2            | 3            |


### [6. Average Post Hiatus (Part 1)](https://datalemur.com/questions/sql-average-post-hiatus-1)

Given a table of Facebook posts, for each user who posted at least twice in 2021, write a query to find the number of days between each user’s first post of the year and last post of the year in the year 2021. Output the user and number of the days between each user's first and last post.

**posts Example Input:**
| user_id | post_id | post_date           | post_content                                       |
| ------- | ------- | ------------------- | -------------------------------------------------- |
| 151652  | 599415  | 07/10/2021 12:00:00 | Need a hug                                         |
| 661093  | 624356  | 07/29/2021 13:00:00 | Bed. Class 8-12. Work 12-3. Gym 3-5 or 6. Then... |
| 004239  | 784254  | 07/04/2021 11:00:00 | Happy 4th of July!                                |
| 661093  | 442560  | 07/08/2021 14:00:00 | Just going to cry myself to sleep after watch... |
| 151652  | 111766  | 07/12/2021 19:00:00 | I'm so done with covid - need travelling ASAP!   |


ANSWER:
```sql
SELECT 
	user_id, 
    MAX(post_date::DATE) - MIN(post_date::DATE) AS days_between
FROM posts
WHERE post_date BETWEEN '01-01-2021' AND '12-31-2021'
GROUP BY user_id
HAVING COUNT(post_id)>1;
```

| user_id | days_between |
| ------- | ------------ |
| 151652  | 307          |
| 661093  | 206          |


### [7. Teams Power Users](https://datalemur.com/questions/teams-power-users)

Write a query to identify the top 2 Power Users who sent the highest number of messages on Microsoft Teams in August 2022. Display the IDs of these 2 users along with the total number of messages they sent. Output the results in descending order based on the count of the messages.

**messages Example Input:**
| message_id | sender_id | receiver_id | content                   | sent_date           |
| ---------- | --------- | ----------- | ------------------------- | ------------------- |
| 901        | 3601      | 4500        | You up?                   | 08/03/2022 00:00:00 |
| 902        | 4500      | 3601        | Only if you're buying     | 08/03/2022 00:00:00 |
| 743        | 3601      | 8752        | Let's take this offline  | 06/14/2022 00:00:00 |
| 922        | 3601      | 4500        | Get on the call           | 08/10/2022 00:00:00 |



ANSWER:
```sql
SELECT sender_id,COUNT(sent_date) AS count_message FROM messages
WHERE sent_date BETWEEN '08-01-2022' AND '08-31-2022'
GROUP BY sender_id
ORDER BY count_message DESC
LIMIT 2;
```

| sender_id | count_message |
| --------- | ------------- |
| 3601      | 4             |
| 2520      | 3             |


### [8. App Click-through Rate](https://datalemur.com/questions/click-through-rate)

Assume you have an events table on Facebook app analytics. Write a query to calculate the click-through rate (CTR) for the app in 2022 and round the results to 2 decimal places.

Definition and note:
+ Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions
+ To avoid integer division, multiply the CTR by 100.0, not 100.

**events Example Input:**
| app_id | event_type | timestamp           |
| ------ | ---------- | ------------------- |
| 123    | impression | 07/18/2022 11:36:12 |
| 123    | impression | 07/18/2022 11:37:12 |
| 123    | click      | 07/18/2022 11:37:42 |
| 234    | impression | 07/18/2022 14:15:12 |
| 234    | click      | 07/18/2022 14:16:12 |


ANSWER:
```sql
SELECT app_id,
 ROUND(
  (
   100.0*COUNT(event_type) FILTER(WHERE event_type = 'click'))
   / 
   (COUNT(event_type) FILTER(WHERE event_type = 'impression')
  ),2) AS ctr
FROM events
WHERE timestamp >= '2022-01-01' 
  AND timestamp < '2023-01-01'
GROUP BY app_id;
```

| app_id | ctr    |
| ------ | ------ |
| 123    | 66.67% |
| 234    | 33.33% |


### [9. Duplicate Job Listings](https://datalemur.com/questions/duplicate-job-listings)

Assume you're given a table containing job postings from various companies on the LinkedIn platform. Write a query to retrieve the count of companies that have posted duplicate job listings.

Definition:
Duplicate job listings are defined as two job listings within the same company that share identical titles and descriptions.

**job_listings Example Input:**
| job_id | company_id | title           | description                                                                                                      |
| ------ | ---------- | --------------- | ---------------------------------------------------------------------------------------------------------------- |
| 248    | 827        | Business Analyst | Business analyst evaluates past and current business data with the primary goal of improving decision-making processes within organizations. |
| 149    | 845        | Business Analyst | Business analyst evaluates past and current business data with the primary goal of improving decision-making processes within organizations. |
| 945    | 345        | Data Analyst     | Data analyst reviews data to identify key insights into a business's customers and ways the data can be used to solve problems.            |
| 164    | 345        | Data Analyst     | Data analyst reviews data to identify key insights into a business's customers and ways the data can be used to solve problems.            |
| 172    | 244        | Data Engineer    | Data engineer works in a variety of settings to build systems that collect, manage, and convert raw data into usable information for data scientists and business analysts to interpret. |



ANSWER:
```sql
WITH  job_posting_cte AS (
      SELECT company_id, title, description, COUNT(company_id) AS total_job_offered FROM job_listings
      GROUP BY  company_id, title, description
     )


SELECT COUNT(DISTINCT company_id) AS duplicated_job FROM job_posting_cte
WHERE total_job_offered > 1;
```

| duplicated_job |
| -------------- |
| 3              |


### [10. Cities With Completed Trades](https://datalemur.com/questions/completed-trades)

Assume you're given the tables containing completed trade orders and user details in a Robinhood trading system.
Write a query to retrieve the top three cities that have the highest number of completed trade orders listed in descending order. Output the city name and the corresponding number of completed trade orders.

**trades Example Input:**
| order_id | user_id | price | quantity | status    | timestamp           |
| -------- | ------- | ----- | -------- | --------- | ------------------- |
| 100101   | 111     | 9.80  | 10       | Cancelled | 08/17/2022 12:00:00 |
| 100102   | 111     | 10.00 | 10       | Completed | 08/17/2022 12:00:00 |
| 100259   | 148     | 5.10  | 35       | Completed | 08/25/2022 12:00:00 |
| 100264   | 148     | 4.80  | 40       | Completed | 08/26/2022 12:00:00 |
| 100305   | 300     | 10.00 | 15       | Completed | 09/05/2022 12:00:00 |
| 100400   | 178     | 9.90  | 15       | Completed | 09/09/2022 12:00:00 |
| 100565   | 265     | 25.60 | 5        | Completed | 12/19/2022 12:00:00 |

**users Example Input:**
| user_id | city          | email                          | signup_date          |
| ------- | ------------- | ------------------------------ | -------------------- |
| 111     | San Francisco | rrok10@gmail.com              | 08/03/2021 12:00:00 |
| 148     | Boston        | sailor9820@gmail.com          | 08/20/2021 12:00:00 |
| 178     | San Francisco | harrypotterfan182@gmail.com   | 01/05/2022 12:00:00 |
| 265     | Denver        | shadower_@hotmail.com         | 02/26/2022 12:00:00 |
| 300     | San Francisco | houstoncowboy1122@hotmail.com | 06/30/2022 12:00:00 |

ANSWER:
```
WITH combined_table 
  AS(
      SELECT * FROM trades
      JOIN users ON trades.user_id = users.user_id
    )

SELECT  city, COUNT(status) AS total_completed FROM combined_table
WHERE status = 'Completed'
GROUP BY city
ORDER BY total_completed DESC
LIMIT 3;
```

| city          | total_completed |
| ------------- | --------------- |
| San Francisco | 4               |
| Boston        | 3               |
| Denver        | 2               |


### [11. Average Review Ratings](https://datalemur.com/questions/sql-avg-review-ratings)

Given the reviews table, write a query to retrieve the average star rating for each product, grouped by month. The output should display the month as a numerical value, product ID, and average star rating rounded to two decimal places. Sort the output first by month and then by product ID.

**reviews Example Input:**
| review_id | user_id | submit_date          | product_id | stars |
| --------- | ------- | -------------------- | ---------- | ----- |
| 6171      | 123     | 06/08/2022 00:00:00  | 50001      | 4     |
| 7802      | 265     | 06/10/2022 00:00:00  | 69852      | 4     |
| 5293      | 362     | 06/18/2022 00:00:00  | 50001      | 3     |
| 6352      | 192     | 07/26/2022 00:00:00  | 69852      | 3     |
| 4517      | 981     | 07/05/2022 00:00:00  | 69852      | 2     |

ANSWER:
```sql
SELECT 
  EXTRACT
    (
      MONTH FROM submit_date) AS mth,product_id, 
      ROUND(AVG(stars),2
    ) AS average_stars
FROM reviews
GROUP BY product_id, mth
ORDER BY mth, product_id;
```
| mth | product_id | average_stars |
| --- | ---------- | ------------- |
| 5   | 25255      | 4.00          |
| 5   | 25600      | 4.33          |
| 6   | 12580      | 4.50          |
| 6   | 50001      | 3.50          |
| 6   | 69852      | 4.00          |
| 7   | 11223      | 5.00          |
| 7   | 69852      | 2.50          |


