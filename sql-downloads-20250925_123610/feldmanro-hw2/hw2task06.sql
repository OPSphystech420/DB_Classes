SELECT DISTINCT m.firstname, m.surname
FROM cd.members m
JOIN cd.members r ON m.memid = r.recommendedby
ORDER BY m.surname, m.firstname;