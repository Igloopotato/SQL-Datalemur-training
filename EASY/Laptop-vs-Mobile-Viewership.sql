SELECT
COUNT(*) FILTER (WHERE device_type = 'laptop') AS laptop_views,
COUNT(*) FILTER (WHERE device_type IN ('tablet', 'phone')) AS mobile_views
FROM Viewership;


----OTHER METHOD BUT HARDER----
ALTER TABLE Viewership
ADD new_device_type TEXT;

UPDATE Viewership
SET new_device_type =
  CASE
    WHEN device_type = 'phone' THEN 'mobile'
    WHEN device_type = 'tablet' THEN 'mobile'
    ELSE device_type
  END;

SELECT 
  SUM(CASE WHEN new_device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views,
  SUM(CASE WHEN new_device_type = 'mobile' THEN 1 ELSE 0 END) AS mobile_views
FROM Viewership;
