WITH  job_posting_cte AS (
      SELECT company_id, title, description, COUNT(company_id) AS total_job_offered FROM job_listings
      GROUP BY  company_id, title, description
     )


SELECT COUNT(DISTINCT company_id) AS duplicated_job FROM job_posting_cte
WHERE total_job_offered > 1
;
