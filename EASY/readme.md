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
