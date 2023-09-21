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
GROUP BY total_tweet.tweet_bucket
;
