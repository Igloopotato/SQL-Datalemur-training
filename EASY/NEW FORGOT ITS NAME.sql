WITH combined_table 
  AS(
      SELECT * FROM trades
      JOIN users ON trades.user_id = users.user_id
    )

SELECT  city, COUNT(status) AS total_completed FROM combined_table
WHERE status = 'Completed'
GROUP BY city
ORDER BY total_completed DESC
LIMIT 3
;
