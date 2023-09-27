SELECT 
  EXTRACT
    (
      MONTH FROM submit_date) AS mth,product_id, 
      ROUND(AVG(stars),2
    ) AS average_stars
FROM reviews
GROUP BY product_id, mth
ORDER BY mth, product_id;
