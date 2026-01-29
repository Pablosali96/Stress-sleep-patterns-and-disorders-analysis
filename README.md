# How Stress, Sleep Duration, and Disorders Affects Multiple Demographics.

## Executive Summary
In recent times, I've developed an interest in the area of health. So, for this project, I decided to search an analyze a dataset with information about sleep duration, stress levels, sleep disorders and more. To this goal, I used SQL (In Visual Studio Code) as my main query tool and Tableau to visualize the data obtained from the dataset. I found that males and females behave in a similar way in terms of sleeping patterns, as well as a negative correlation between sleep duration and stress levels.

SQL queries can be found here: [sql_queries](/sql_queries/) 
## Analytical Questions

The questions puzzled me for this project were the following:

- How does sleeping hours differ between males and female?
- What ages and occupations suffer the most from sleep disorders?
- Does high levels of stress influence sleeping patterns and disorders?

## Dataset Overview
The dataset comes from Kaggle found in the following link: [Sleep Health and Lifestyle Dataset](https://www.kaggle.com/datasets/uom190346a/sleep-health-and-lifestyle-dataset)

It has 374 rows of data with 13 Columns with the following description:

| No | Field | Type | Description |
| -- | -- | -- | -- |
| 1 | Person ID | Integer | Id for each individual |
| 2 | Gender | String | Gender of the participant (Male/Female) |
| 3 | Age | Integer | Age of the participant in years |
| 4 | Occupation | String | Occupation/profession of the participant |
| 5 | Sleep Duration | Float | Duration of sleep per day in hours |
| 6 | Quality of Sleep | Integer | Subjective rating from 1 - 10 of the quality of sleep |
| 7 | Physical Activity Level | Integer | Number of minutes each person engages daily |
| 8 | Stress Level | Integer | Subjective rating from 1 - 10 of the stress experience by each participant |
| 9 | BMI Category | String | BMI category of the participant |
| 10 | Blood Pressure | String | Blood pressure of the person, indicated as systolic pressure over diastolic pressure |
| 11 | Heart Rate | Integer | Resting heart rate of the participant in beats per minute |
| 12 | Daily Steps | Integer | Number of daily steps of the participant |
| 13 | Sleep Disorder | String | Presence or absence of a sleep disorder in the participant |

## Limitations AND Assumptions

- This dataset is synthetic and created by the author, the insights derived from this project may not be transferable to the real life.
- Some data (quality of sleep, stress level) is self reported without following a clear guideline.
- Other factors such as: Mental health, work environment, alcohol consumption or smoking status are not present. These factor can influence sleeping patterns and stress levels.
- Depending on the scope of the project (is it done at a town, city, country level?), the amount of participants may be not enough to reflect the whole population.

## Tools Used 

- Excel 
- SQL (postgresSQL & Visual Studio Code)
- Tableau (Visualization/Dashboards)
- Github (documentation)

## Data Cleaning

This process took place both in Excel and SQL. Excel allowed me to change the names of the fields to a more standardized and SQL friendly format ("Person ID" to "person_id"). SQL allowed me to correct repetitive fields as well as create bins for fields such as "age" and "daily_steps"

```sql
SELECT
    bmi_category_cleaned,
    COUNT(*),
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_total
FROM (
    SELECT
        *,
        CASE bmi_category
            WHEN 'Normal Weight' THEN 'Normal'
            ELSE bmi_category
        END as bmi_category_cleaned
    FROM sleepdata
) as sleep_bmi
GROUP BY 1
ORDER BY 2 DESC;
```

```sql 
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
```

```sql
WITH sleep_steps AS(
    SELECT
        *,
         CASE 
            WHEN daily_steps >= 3000 AND daily_steps < 4000 THEN '[3k-4k]'
            WHEN daily_steps >= 4000 AND daily_steps < 5000 THEN '[4k-5k]'
            WHEN daily_steps >= 5000 AND daily_steps < 6000 THEN '[5k-6k]'
            WHEN daily_steps >= 6000 AND daily_steps < 7000 THEN '[6k-7k]'
            WHEN daily_steps >= 7000 AND daily_steps < 8000 THEN '[7k-8k]'
            WHEN daily_steps >= 8000 AND daily_steps < 9000 THEN '[8k-9k]'
            WHEN daily_steps >= 9000 AND daily_steps < 10000 THEN '[9k-10k]'
            ELSE '[10k+]'
        END as daily_steps_bin
    FROM sleepdata
)
SELECT
   daily_steps_bin,
    COUNT(*) as number_of_participants,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_total
FROM sleep_steps
GROUP BY 1
ORDER BY 2 DESC;
```

## Data Analysis

### 1. How does sleeping hours differ between males and female?


![Male vs Female Sleep Duration](assets/Male%20vs%20Female%20Sleep%20Duration.png)

## Key Insights

## Conclusion 