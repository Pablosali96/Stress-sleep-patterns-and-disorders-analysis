--Data Exploration

--Total number of rows
SELECT
	COUNT(*)
FROM sleepdata;
--374 rows of data

--Null values check
SELECT
	COUNT(*) - COUNT(person_id),
	COUNT(*) - COUNT(gender),
	COUNT(*) - COUNT(age),
	COUNT(*) - COUNT(occupation),
	COUNT(*) - COUNT(sleep_duration),
	COUNT(*) - COUNT(quality_of_sleep),
	COUNT(*) - COUNT(physical_activity_level),
    COUNT(*) - COUNT(stress_level),
    COUNT(*) - COUNT(bmi_category),
    COUNT(*) - COUNT(blood_pressure),
    COUNT(*) - COUNT(heart_rate),
    COUNT(*) - COUNT(daily_steps),
    COUNT(*) - COUNT(sleep_disorder)
FROM sleepdata;
--0 Null values all across the board

--Gender values count
SELECT
    gender,
    COUNT(*) as number_of_participants,
    (COUNT(*) * 100 / (SELECT COUNT(*) FROM sleepdata))as genderpercentage
FROM sleepdata
GROUP BY 1;
--Almost a 50/50 split for both female and male

--Age values count
SELECT
    CASE    
        WHEN age >= 25 AND age < 30 THEN '[25-30]'
        WHEN age >= 30 AND age < 35 THEN '[30-35]'
        WHEN age >= 35 AND age < 40 THEN '[35-40]'
        WHEN age >= 40 AND age < 45 THEN '[40-45]'
        WHEN age >= 45 AND age < 50 THEN '[45-50]'
        WHEN age >= 50 AND age < 55 THEN '[50-55]'
    ELSE '[55-60]'
    END as age_bins,
    COUNT(*) as number_of_participants,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_total
FROM sleepdata
GROUP BY 1
ORDER BY 2 DESC;
--Most of the participants are between their 30s to 50s

--Sleep disorders per participants
SELECT
    sleep_disorder,
    COUNT(*),
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_total
FROM sleepdata
GROUP BY 1
ORDER BY 2 DESC;
/* Most than half of the participants don't have a sleep disorder,
The other two disorders are present in almost the same quantity on the remaining participants*/

--Occupation representation among the participants
SELECT
    occupation,
    COUNT(*) number_of_participants,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_total
FROM sleepdata
GROUP BY 1
ORDER BY 2 DESC;
-- Top 3 professions are: Nurse, Doctor and Engineer

