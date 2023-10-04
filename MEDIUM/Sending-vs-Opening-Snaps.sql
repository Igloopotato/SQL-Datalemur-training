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
