SELECT DISTINCT m.firstname || ' ' || m.surname AS member,
                f.name AS facility
FROM cd.bookings b
JOIN cd.members m ON b.memid = m.memid
JOIN cd.facilities f ON b.facid = f.facid
WHERE f.name LIKE 'Tennis Court%'
ORDER BY member, facility;
