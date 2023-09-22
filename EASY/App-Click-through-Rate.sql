SELECT app_id, ROUND(
  (
  100.0*COUNT(event_type) FILTER(WHERE event_type = 'click'))
  / 
  (COUNT(event_type) FILTER(WHERE event_type = 'impression')
  )
  ,2) AS ctr FROM events
WHERE timestamp >= '2022-01-01' 
  AND timestamp < '2023-01-01'
GROUP BY app_id;
