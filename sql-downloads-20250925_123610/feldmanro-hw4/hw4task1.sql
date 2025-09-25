WITH RECURSIVE fib (nth, value, next_val) AS (
    SELECT 0::INT             AS nth,
           1::NUMERIC         AS value,
           1::NUMERIC         AS next_val
    UNION ALL
    SELECT
        nth + 1,
        next_val,
        value + next_val
    FROM fib
    WHERE nth < 99
)
SELECT nth, value
FROM fib
ORDER  BY nth;
