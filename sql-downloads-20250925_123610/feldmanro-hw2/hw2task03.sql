SELECT facid,
EXTRACT(MONTH FROM starttime) AS month,
SUM(slots) AS total_slots
FROM cd.bookings
WHERE EXTRACT(YEAR FROM starttime) = 2012
GROUP BY facid, EXTRACT(MONTH FROM starttime) ORDER BY facid, month;