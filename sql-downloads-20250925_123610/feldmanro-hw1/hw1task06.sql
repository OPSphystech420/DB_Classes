SELECT dt, high_price, vol FROM public.coins 
WHERE symbol = 'DOGE' AND CAST(dt AS DATE) >= '2018-01-01' AND CAST(dt AS DATE) < '2019-01-01' AND avg_price > 0.001;