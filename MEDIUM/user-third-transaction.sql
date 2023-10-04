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
