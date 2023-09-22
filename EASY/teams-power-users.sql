SELECT sender_id,COUNT(sent_date) AS count_message FROM messages
WHERE sent_date BETWEEN '08-01-2022' AND '08-31-2022'
GROUP BY sender_id
ORDER BY count_message DESC
LIMIT 2;
