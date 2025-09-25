SELECT
CASE
    WHEN memid = 0 THEN 'GUEST GUEST'
    ELSE (SELECT firstname || ' ' || surname FROM cd.members WHERE memid = b.memid)
END AS member,
(SELECT name FROM cd.facilities WHERE facid = b.facid) AS facility,
CASE
    WHEN memid = 0 THEN slots * (SELECT guestcost FROM cd.facilities WHERE facid = b.facid)
    ELSE slots * (SELECT membercost FROM cd.facilities WHERE facid = b.facid)
END AS cost
FROM cd.bookings b
WHERE DATE(starttime) = '2012-09-14' AND(
    CASE
        WHEN memid = 0 THEN slots * (SELECT guestcost FROM cd.facilities WHERE facid = b.facid)
        ELSE slots * (SELECT membercost FROM cd.facilities WHERE facid = b.facid)
    END) > 30
ORDER BY cost DESC, member, facility;
