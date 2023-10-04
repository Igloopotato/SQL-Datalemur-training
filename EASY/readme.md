# DataLemur Analysis

This repository contains my answers to a set of easy SQL-related questions in [DataLemur](https://datalemur.com/), where I have answered various questions using the provided dataset.

## Table of Contents

- [Introduction](#introduction)
- [Questions and Answers](#questions-and-answers)
  - [Question 1: Page With No Likes](#-1.Page-With-No-Likes)
  - [Question 2: Another SQL Question](#question-2-another-sql-question)
  - [Question 3: Yet Another Question](#question-3-yet-another-question)
- [Conclusion](#conclusion)
- [License](#license)

## Introduction

In this repository, I have provided answers to a series of easy SQL-related questions. These questions cover fundamental SQL concepts and operations.

## Questions And Answers

# 1.Page With No Likes

Assume you're given two tables containing data about Facebook Pages and their respective likes (as in "Like a Facebook Page").

Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in ascending order based on the page IDs.

**pages Example Input:**                           **page_likes Example Input:**

| page_id | page_name |                            |user_id|page_id|liked_date|
|:------:|------------|                            |:------:|-------|-----------|
|20001|	SQL Solutions|
|20045|	Brain Exercises|
|20701|	Tips for Data Analysts|


Link to the case study and datasets used:[here](https://datalemur.com/questions/sql-page-with-no-likes)

Answer:
```sql
SELECT pages.page_id FROM pages 
LEFT OUTER JOIN page_likes ON page_likes.page_id = pages.page_id
 WHERE Liked_date IS NULL
ORDER BY pages.page_id;
```
