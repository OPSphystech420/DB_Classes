WITH coin_price AS (
    SELECT
        UPPER(full_nm) AS full_name,
        dt,
        high_price,
        ROW_NUMBER() OVER ( PARTITION BY full_nm ORDER BY high_price DESC, dt asc ) AS rn
    FROM public.coins
)
SELECT full_name, dt, high_price AS price
FROM coin_price
WHERE rn = 1
ORDER BY price DESC, full_name ASC;