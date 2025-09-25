WITH daily_vol AS (
    SELECT dt, SUM(vol) AS daily_vol
    FROM public.coins
    GROUP BY dt
)
SELECT ROW_NUMBER() OVER (ORDER BY daily_vol DESC) AS rank, dt, daily_vol AS vol
FROM daily_vol
ORDER BY rank
LIMIT 10;
