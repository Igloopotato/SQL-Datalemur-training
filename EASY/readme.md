# DataLemur Analysis

This repository contains my answers to a set of easy SQL-related questions in [DataLemur](https://datalemur.com/), where I have answered various questions using the provided dataset.

## Table of Contents

- [Introduction](#introduction)
- [Questions and Answers](#questions-and-answers)
  - [Question 1: Page With No Likes](###-1.-Page-With-No-Likes])
  - [Question 2: Another SQL Question](#question-2-another-sql-question)
  - [Question 3: Yet Another Question](#question-3-yet-another-question)
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

