SELECT
CASE
	WHEN GROUPING(facid) = 1 THEN NULL 
	ELSE facid
END AS facid,
CASE 
	WHEN GROUPING(EXTRACT(MONTH FROM starttime)) = 1 THEN NULL
    ELSE EXTRACT(MONTH FROM starttime) 
END AS month,
SUM(slots) AS slots
FROM cd.bookings
WHERE EXTRACT(YEAR FROM starttime) = 2012
GROUP BY GROUPING SETS
(
    (facid, EXTRACT(MONTH FROM starttime)),
    (facid),
    ()
) ORDER BY facid NULLS LAST, month NULLS LAST;
