SELECT candidate_id FROM candidates
WHERE skill IN ('Python','PostgreSQL','Tableau')
GROUP BY candidate_id
HAVING COUNT(skill) = 3
ORDER BY candidate_id ASC;
