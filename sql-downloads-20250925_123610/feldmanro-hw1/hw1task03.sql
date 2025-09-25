SELECT COUNT(*) AS underweight_count FROM public.hw
WHERE (703 * 1.0001092375 * weight) / (height * height) < 18.5;