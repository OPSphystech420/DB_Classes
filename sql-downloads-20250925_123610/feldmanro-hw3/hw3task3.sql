SELECT m.firstname, m.surname,
ROUND(SUM(COALESCE(b.slots, 0)) * 0.5 / 10) * 10 as hours,
RANK() OVER (ORDER BY ROUND(SUM(COALESCE(b.slots, 0)) * 0.5 / 10) * 10 DESC) as rank
FROM cd.members m
LEFT JOIN cd.bookings b ON m.memid = b.memid
GROUP BY m.memid, m.firstname, m.surname
ORDER BY rank, m.surname, m.firstname;