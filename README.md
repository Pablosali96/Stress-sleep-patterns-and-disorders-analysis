# How Stress, Sleep Duration, and Disorders Affects Multiple Demographics.

## Executive Summary

This project analyzes the relationship between stress levels, sleep durations and sleep disorders across multiple demographics groups. Using SQL for data extraction, cleaning and analysis as well as tableau for data visualization, the analysis aims to explore how these variables affect different genders, age groups and occupations.

The results show that sleep duration is similar among genders and age groups, but those within the ages of 40-50, specially in areas of health and education, show higher prevalence of sleep disorders. Additionally, the analysis shows a clear inverse relationship between sleep duration and stress levels, suggesting that reduced time of sleep may indicate higher levels of reported stress. 

SQL queries can be found here: [sql_queries](/sql_queries/) 
## Analytical Questions

The questions that guided this project were:

- Which demographics are sleeping the least?
- What ages and occupations suffer the most from sleep disorders?
- Do higher stress levels influence sleep duration and presence of sleep disorders?

## Dataset Overview
The dataset was sourced from Kaggle and it can be found in the following link: [Sleep Health and Lifestyle Dataset](https://www.kaggle.com/datasets/uom190346a/sleep-health-and-lifestyle-dataset)

The following is a description of the dataset which contains 374 rows and 13 columns:

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

- This dataset is synthetic and created by the author, the insights derived from this project may not be transferable to real-world populations.
- Some variables (quality of sleep, stress level) are self reported without following a clear guideline, this may result in reporting bias.
- Other factors such as: Mental health, work environment, alcohol consumption or smoking status are not present. These factor may influence sleeping patterns and stress levels.
- Depending on the scope of the project (is it done at a town, city, country level?), the amount of participants may be not enough to reflect broader populations.

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

### 1. Which demographics are sleeping the least?


![Male vs Female Sleep Duration](assets/Gender%20Sleep%20Duration.png)

The graph shows the difference in sleep duration between Females and Males broken down by age group.

For this analysis, Females between the ages 50-60 years old were excluded. Males were not represented in these age groups which inflated the averages of females setting them on top among both groups.

The differences are minimal between the genders but there is a consistent pattern among the age groups of males sleeping more than females. The differences a more pronounce in the age groups of 30-35 years old and 45-50 years old 

### 2. What ages and occupations suffer the most from sleep disorders?

#### Insomnia
![Insomnia Analysis](assets/Insomnia%20Analysis.png)

The graph shows a breakdown of the participants with insomnia by gender, age group and profession.

We can see an almost 60/40% split between males and females respectively of those who suffer insomnia. We also see that most of them are between the ages of 40-45 years old and the professions of Salesperson and Teachers are the most affected.


#### Sleep Apnea
![Sleep Apnea Analysis](assets/Sleep%20Apnea%20Analysis.png)

The graph shows a breakdown of the participants with sleep apnea by gender, age group and profession.

As with the previous disorder, the split between of males and females is almost 60/40% respectively. The age group of 45-50 years old is the most affected by this disorder with Nurses being on top of the profession followed by Doctors and Teachers.

### 3. Do higher stress levels influence sleep duration and presence of sleep disorders?

![Sleep Duration vs Stress Level Graph](assets/Sleep%20Duration%20vs%20Stress%20Levels.png)

The graph illustrates the average sleep duration with the average stress levels by age group.

The group of 25-30 years old report the lowest average sleep duration which may be one of the factors that influence their high levels of stress while the group of 35-40 years old shows the opposite pattern.

![Sleep Duration Stress Level Corr](assets/Sleep%20Duration%20Stress%20Level%20Correlation.png)
Note: The axis in this graph do not start from 0.

![Correlation Coeficient Value](assets/Correlation%20Coeficient.png)

Here we see a negative correlation between the Sleep Duration and the Stress Level. The more hours of sleep an individual presents, the lower the stress level reported overall. This may be a contributing factor among many which were not accounted in the dataset.

## Key Insights

1. Among all age groups, female are, on average, sleeping less time than males. Age wise, men show increasing sleep duration as they grow older, while women present an increase duration at the ages of 35-40 followed but a decline on subsequent ages.

    With gender not being a strong indicator. Companies may spend their resources in addressing other factors such as age, stress and occupation instead of focusing on gender-based programs that tackle sleep-related problems.

2. Sleep disorders affects, the most, participants between the ages of 40-50 years old with Teachers being the most affected by both insomnia and sleep apnea followed by health-related occupation such a doctors and nurses.

    These occupations are vital to the growth of populations. Companies in the sectors of health and education may see benefits on implementing programs that help new talents or professionals progressing in their career. These programs can guide them on how to deal with these disorders by providing counselling as well as guidelines on how to identify and address them.

3. There is a strong negative relationship (correlation coefficient: -0.811) between the amount of hours slept and the stress levels across the age groups. Younger people who are affected by high stress levels present lower sleep durations while older participant see the opposite trend.

    Duration of sleep should be a key factor to focus, specially in younger people, as it shows that it can be a substantial factor in regulating stress. Programs that incentivize a better sleep routine and foster sleep quality should be prioritize as the outcomes lead to better performance both at work and at schools/universities, higher life expectancy, happier relationships and better decision-making.

## Conclusion & Next Steps

Both genders have similar sleeping patterns when we refer to the hours they sleep and the disorders they suffer. Stress and hours of sleep show a clear negative correlation with young participants sleeping less and presenting higher levels of stress. 

More lifestyle variables such as alcohol consumption, smoking status, caffeine intake and employment status could provide deeper insights into the relationship between stress levels and sleep patterns relate. 