WITH RECURSIVE rec_chain AS (
    SELECT memid, firstname, surname, recommendedby
    FROM cd.members
    WHERE recommendedby = 1
    UNION ALL
    SELECT m.memid, m.firstname, m.surname, m.recommendedby
    FROM cd.members m
    JOIN rec_chain r ON m.recommendedby = r.memid
)
SELECT memid, firstname, surname
FROM rec_chain
ORDER BY memid;