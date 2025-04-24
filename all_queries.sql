create database milestone;
show databases;
use milestone;

UPDATE salary_table_clean
SET Gender = 'Prefer not to answer'
WHERE Gender = 'Other or prefer not to answer';


show tables;
ALTER TABLE salary_table_clean
RENAME COLUMN `Job _title` TO Job_title;


ALTER TABLE salary_table_clean
RENAME COLUMN `ï»¿Age_range` TO Age_range;


ALTER TABLE salary_table
RENAME COLUMN `Annual_salary _USD` TO Annual_salary_USD;
/* a. Compare the average salary within each industry, split by gender. This
helps identify potential salary discrepancies based on gender within
industries. */
select * from salary_table_clean;
SELECT Industry, Gender, ROUND(AVG(Annual_salary_USD), 2) AS average_salary
FROM salary_table_clean
GROUP BY Industry, Gender
ORDER BY Industry, Gender;

/* b.find the total monetary compensation (base salary + additional monetary
compensation) for each job title. This can show which roles have the
highest overall compensation. */
select * from salary_table_clean;
SELECT 
    Job_title, 
    ROUND(SUM(Annual_salary_USD + Additional_m_c_USD), 2) AS total_compensation
FROM salary_table_clean
GROUP BY Job_title
ORDER BY total_compensation DESC;

/*c. Find the salary distribution (average salary, minimum, and maximum) for
different education levels. This helps analyze the correlation between
education and salary */
select Highest_level_of_education,avg(Annual_salary_USD),
min(Annual_salary_USD), max(Annual_salary_USD)
from salary_table_clean group by Highest_level_of_education;

/* d.Determine how many employees are in each industry, broken down by
years of professional experience. This can show if certain industries
employ more experienced professionals.*/

select * from salary_table_clean;
select count(*) count_of_employee, Industry,yo_p_e_in_Field from 
salary_table_clean group by Industry,yo_p_e_in_Field
order by count(*) desc;

/* e.Calculate the median salary within different age ranges and genders. This
can provide insights into salary trends across different age groups and
gender*/
WITH Ranked AS (
    SELECT 
        Age_range,
        Gender,
        Annual_salary_USD,
        ROW_NUMBER() OVER (PARTITION BY Age_range, Gender ORDER BY Annual_salary_USD) AS rn,
        CEIL(COUNT(*) OVER (PARTITION BY Age_range, Gender) / 2.0) AS mid
    FROM salary_table
)
SELECT 
    Age_range,
    Gender,
    ROUND(AVG(Annual_salary_USD), 2) AS median_salary
FROM Ranked
WHERE rn IN (mid, mid + 1)
GROUP BY Age_range, Gender
ORDER BY Age_range, Gender;

/*
Find the highest-paying job titles in each country. This can help understand
salary trends across different countries and highlight high-paying
positions. */
select * from salary_table_clean;
WITH AvgCompensation AS (
    SELECT 
        Country,
        Job_title,
        ROUND(AVG(Annual_salary_USD + Additional_m_c_USD), 2) AS avg_total_compensation,
        RANK() OVER (PARTITION BY Country ORDER BY AVG(Annual_salary_USD + Additional_m_c_USD) DESC) AS salary_rank
    FROM salary_table_clean
    GROUP BY Country, Job_title
)
SELECT 
    Country,
    Job_title,
    avg_total_compensation
FROM AvgCompensation
WHERE salary_rank = 1
ORDER BY Country, avg_total_compensation DESC;

/* g. Calculate the average salary for each combination of city and industry.
This shows which cities offer higher salaries within each industry.*/
SELECT 
    City,
    Industry,
    ROUND(AVG(Annual_salary_USD), 2) AS average_salary
FROM salary_table_clean
GROUP BY City, Industry
ORDER BY City, Industry;

/* h. Find the percentage of employees within each gender who receive
additional monetary compensation, such as bonuses or stock options. */
SELECT 
    Gender,
    ROUND(
        (SUM(CASE WHEN Additional_m_c_USD > 0 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS percentage_with_compensation
FROM salary_table_clean
GROUP BY Gender
ORDER BY Gender;

/* i. Determine the total compensation (salary + additional compensation) for
each job title based on years of professional experience. This can help
highlight compensation trends based on experience levels within specific
job titles */
select * from salary_table_clean;
SELECT 
    Job_title,
    y_o_p_e_Overall as years_of_experience,
    ROUND(AVG(Annual_salary_USD + Additional_m_c_USD), 2) AS avg_total_compensation
FROM salary_table_clean
GROUP BY Job_title, y_o_p_e_Overall
ORDER BY Job_title, y_o_p_e_Overall;

/* j. Understand how salary varies by industry, gender, and education level.
This query can provide a comprehensive view of how multiple factors
influence salary. */
SELECT 
    Industry,
    Gender,
    Highest_level_of_education,
    ROUND(AVG(Annual_salary_USD), 2) AS average_salary
FROM salary_table_clean
GROUP BY Industry, Gender, Highest_level_of_education
ORDER BY Industry, Gender, Highest_level_of_education;













