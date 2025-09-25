SELECT 
    f.name,
    CASE 
        WHEN NTILE(3) OVER (ORDER BY SUM(
            CASE 
                WHEN b.memid = 0 THEN f.guestcost * b.slots 
                ELSE f.membercost * b.slots 
            END
        ) DESC) = 1 THEN 'high'
        WHEN NTILE(3) OVER (ORDER BY SUM(
            CASE 
                WHEN b.memid = 0 THEN f.guestcost * b.slots 
                ELSE f.membercost * b.slots 
            END
        ) DESC) = 2 THEN 'average'
        ELSE 'low'
    END as revenue
FROM cd.facilities f
JOIN cd.bookings b ON f.facid = b.facid
GROUP BY f.name
ORDER BY 
    CASE 
        WHEN NTILE(3) OVER (ORDER BY SUM(
            CASE 
                WHEN b.memid = 0 THEN f.guestcost * b.slots 
                ELSE f.membercost * b.slots 
            END
        ) DESC) = 1 THEN 1
        WHEN NTILE(3) OVER (ORDER BY SUM(
            CASE 
                WHEN b.memid = 0 THEN f.guestcost * b.slots 
                ELSE f.membercost * b.slots 
            END
        ) DESC) = 2 THEN 2
        ELSE 3
    END, 
    f.name;