SELECT f.name,
    DENSE_RANK() OVER (ORDER BY SUM(
        CASE 
            WHEN b.memid = 0 THEN f.guestcost * b.slots 
            ELSE f.membercost * b.slots 
        END
    ) DESC) as rank
FROM cd.facilities f
JOIN cd.bookings b ON f.facid = b.facid
GROUP BY f.name
ORDER BY rank, f.name
LIMIT 3;