--Data Analysis

--Average quality of sleep per gender and age bin
WITH sleep_set AS (
    SELECT
        *,
        CASE    
            WHEN age >= 25 AND age < 30 THEN '[25-30]'
            WHEN age >= 30 AND age < 35 THEN '[30-35]'
            WHEN age >= 35 AND age < 40 THEN '[35-40]'
            WHEN age >= 40 AND age < 45 THEN '[40-45]'
            WHEN age >= 45 AND age < 50 THEN '[45-50]'
            WHEN age >= 50 AND age < 55 THEN '[50-55]'
        ELSE '[55-60]'
        END as age_bins
    FROM sleepdata
)
SELECT
    gender,
    age_bins,
    ROUND(AVG(quality_of_sleep),2) as avg_quality_of_sleep
FROM sleep_set
GROUP BY 1,2
ORDER BY 1,3 DESC;

/*Females approaching in their 30s all the way to their 60s report high qualities of sleep on average.
Males on follow this pattern with older man from their 40 to their 50 reporting on average high quality of sleep*/

-- Average quality of sleep per gender and occupation
SELECT
    gender,
    occupation,
    ROUND(AVG(quality_of_sleep),2) as avg_quality_of_sleep
FROM sleepdata
GROUP BY 1,2
ORDER BY 1,3 DESC;
/*Profession wise, females from multiple occupations report, on average, high quality of sleep with Engineers and Doctors being on top
For males, The average value is lower than their counterparts overall with Lawyers and Engineers being on top*/ 

--Blood pressure and physical activity levels
SELECT
    blood_pressure,
    ROUND(AVG(physical_activity_level),2) as avg_activity_level
FROM sleepdata
GROUP BY 1
ORDER BY 2 DESC;
--High levels of physical activity are not directly correlated low blood pressure

--Average sleep duration per gender and occupation
SELECT
    gender,
    occupation,
    ROUND(AVG(sleep_duration),2) as avg_sleep_duration
FROM sleepdata
GROUP BY 1,2
ORDER BY 1,3 DESC;
--Overall, the average quality of sleep and the average sleep duration are on part for both genders and occupation

--Correlation between sleep duration and stress levels
SELECT
    CORR(stress_level, sleep_duration) as correlation_coeficient
FROM sleepdata
--Negative correlation between these variables

--Sleep duration vs stress level by age bin
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
    ROUND(AVG(sleep_duration),2) as avg_sleep_duration,
    ROUND(AVG(stress_level),2) as avg_stress_level
FROM sleep_set
GROUP BY 1
ORDER BY 2 DESC;
--age groups that present higher durations of sleep, present as well lower levels of stress overall

