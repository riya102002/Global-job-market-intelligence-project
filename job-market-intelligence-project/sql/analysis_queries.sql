-- 1. Check available tables
SELECT name
FROM sqlite_master
WHERE type='table';

-- 2. Check table structure
PRAGMA table_info(job_market);

-- 3. View first 10 rows
SELECT *
FROM job_market
LIMIT 10;

-- 4. Total number of job records
SELECT COUNT(*) AS total_jobs
FROM job_market;

-- 5. Top 10 most common job titles
SELECT job_title,
       COUNT(*) AS job_count
FROM job_market
GROUP BY job_title
ORDER BY job_count DESC
LIMIT 10;

-- 6. Top 10 highest paying job titles
SELECT job_title,
       AVG(salary_in_usd) AS avg_salary
FROM job_market
GROUP BY job_title
ORDER BY avg_salary DESC
LIMIT 10;

-- 7. Average salary by experience level
SELECT experience_level,
       AVG(salary_in_usd) AS avg_salary
FROM job_market
GROUP BY experience_level
ORDER BY avg_salary DESC;

-- 8. Average salary by employment type
SELECT employment_type,
       AVG(salary_in_usd) AS avg_salary
FROM job_market
GROUP BY employment_type
ORDER BY avg_salary DESC;

-- 9. Remote vs Onsite vs Hybrid job distribution
SELECT
CASE
    WHEN remote_ratio = 100 THEN 'Remote'
    WHEN remote_ratio = 0 THEN 'Onsite'
    ELSE 'Hybrid'
END AS work_mode,
COUNT(*) AS total_jobs
FROM job_market
GROUP BY work_mode;

-- 10. Average salary by work mode
SELECT
CASE
    WHEN remote_ratio = 100 THEN 'Remote'
    WHEN remote_ratio = 0 THEN 'Onsite'
    ELSE 'Hybrid'
END AS work_mode,
AVG(salary_in_usd) AS avg_salary
FROM job_market
GROUP BY work_mode
ORDER BY avg_salary DESC;

-- 11. Top 10 countries by number of jobs
SELECT country,
       COUNT(*) AS total_jobs
FROM job_market
GROUP BY country
ORDER BY total_jobs DESC
LIMIT 10;

-- 12. Top 10 countries by average salary
SELECT country,
       AVG(salary_in_usd) AS avg_salary
FROM job_market
GROUP BY country
ORDER BY avg_salary DESC
LIMIT 10;



-- 14. Salary statistics
SELECT
MIN(salary_in_usd) AS min_salary,
MAX(salary_in_usd) AS max_salary,
AVG(salary_in_usd) AS avg_salary
FROM job_market;

-- 15. Jobs paying above average salary
SELECT job_title,
       company_name,
       salary_in_usd
FROM job_market
WHERE salary_in_usd >
(
SELECT AVG(salary_in_usd)
FROM job_market
);

-- 16. Job count by experience level
SELECT experience_level,
       COUNT(*) AS total_jobs
FROM job_market
GROUP BY experience_level
ORDER BY total_jobs DESC;

-- 17. Job count by employment type
SELECT employment_type,
       COUNT(*) AS total_jobs
FROM job_market
GROUP BY employment_type
ORDER BY total_jobs DESC;

-- 18. Average remote ratio by job title
SELECT job_title,
       AVG(remote_ratio) AS avg_remote_ratio
FROM job_market
GROUP BY job_title
ORDER BY avg_remote_ratio DESC
LIMIT 10;

-- 19. Highest paying companies on average
SELECT company_name,
       AVG(salary_in_usd) AS avg_salary
FROM job_market
GROUP BY company_name
ORDER BY avg_salary DESC
LIMIT 10;

-- 20. Countries with most fully remote jobs
SELECT country,
       COUNT(*) AS remote_jobs
FROM job_market
WHERE remote_ratio = 100
GROUP BY country
ORDER BY remote_jobs DESC
LIMIT 10;

-- 21.  Rank job titles by average salary
SELECT
    job_title,
    AVG(salary_in_usd) AS avg_salary,
    RANK() OVER (ORDER BY AVG(salary_in_usd) DESC) AS salary_rank
FROM job_market
GROUP BY job_title
ORDER BY salary_rank
LIMIT 10;

-- 22: Top paying job in each experience level
WITH ranked_jobs AS (
    SELECT
        experience_level,
        job_title,
        AVG(salary_in_usd) AS avg_salary,
        RANK() OVER (
            PARTITION BY experience_level
            ORDER BY AVG(salary_in_usd) DESC
        ) AS rank_within_experience
    FROM job_market
    GROUP BY experience_level, job_title
)
SELECT
    experience_level,
    job_title,
    avg_salary,
    rank_within_experience
FROM ranked_jobs
WHERE rank_within_experience = 1
ORDER BY avg_salary DESC;