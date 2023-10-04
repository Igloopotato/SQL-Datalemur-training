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
