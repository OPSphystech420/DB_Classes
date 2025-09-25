SELECT firstname || ' ' || surname AS member,
(
  SELECT firstname || ' ' || surname 
  FROM cd.members 
  WHERE memid = m.recommendedby
) AS recommender
FROM cd.members m
ORDER BY member;

