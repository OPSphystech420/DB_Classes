SELECT m.surname, m.firstname, m.memid, b.first_booking AS starttime
FROM cd.members m
JOIN
(
    SELECT memid, MIN(starttime) AS first_booking
    FROM cd.bookings
    WHERE starttime >= '2012-09-01'
    GROUP BY memid
) b ON m.memid = b.memid
ORDER BY m.memid;
