WITH bmi_data AS
(
    SELECT id, (703 * 1.0001092375 * weight) / (height * height) AS bmi
    FROM public.hw
)
SELECT id, bmi,
CASE 
	WHEN bmi < 18.5 THEN 'underweight'
	WHEN bmi < 25 THEN 'normal'
	WHEN bmi < 30 THEN 'overweight'
	WHEN bmi < 35 THEN 'obese'
	ELSE 'extremely obese'
END AS type
FROM bmi_data
ORDER BY bmi DESC, id DESC;

