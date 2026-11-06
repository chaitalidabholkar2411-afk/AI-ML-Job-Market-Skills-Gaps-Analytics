USE ai_ml_job_markets;

SELECT * FROM jobs;

-- Companies dataset
SELECT * FROM companies;

-- Locations dataset
SELECT * FROM locations;

-- Skills dataset
SELECT * FROM skills;

-- Jobs dataset
SELECT * FROM jobs;

-- Job skills dataset
SELECT * FROM job_skills;

-- Job postings dataset
SELECT * FROM job_postings;


SELECT
    j.job_id,
    c.company_name,
    j.job_title,
    l.city,
    j.experience_min,
    j.experience_max,
    j.salary_min,
    j.salary_max,
    j.work_mode,
    s.skill_name,
    js.required_level,
    jp.source,
    jp.application_count,
    jp.status
FROM jobs j
JOIN companies c
    ON j.company_id = c.company_id
JOIN locations l
    ON j.location_id = l.location_id
LEFT JOIN job_skills js
    ON j.job_id = js.job_id
LEFT JOIN skills s
    ON js.skill_id = s.skill_id
LEFT JOIN job_postings jp
    ON j.job_id = jp.job_id
ORDER BY j.job_id, s.skill_name;



-- 1. Total jobs
SELECT COUNT(*) AS total_jobs FROM jobs;

-- 2. Total companies
SELECT COUNT(*) AS total_companies FROM companies;

-- 3. Total skills in database
SELECT COUNT(*) AS total_skills FROM skills;

-- 4. Jobs by job title
SELECT job_title, COUNT(*) AS job_count
FROM jobs
GROUP BY job_title
ORDER BY job_count DESC;

-- 5. Jobs by work mode
SELECT work_mode, COUNT(*) AS total_jobs
FROM jobs
GROUP BY work_mode
ORDER BY total_jobs DESC;

-- 6. Jobs by city
SELECT l.city, COUNT(*) AS total_jobs
FROM jobs j
JOIN locations l ON j.location_id = l.location_id
GROUP BY l.city
ORDER BY total_jobs DESC;

-- 7. Jobs by company
SELECT c.company_name, COUNT(*) AS total_jobs
FROM jobs j
JOIN companies c ON j.company_id = c.company_id
GROUP BY c.company_name
ORDER BY total_jobs DESC;

-- 8. Average salary by job title
SELECT job_title,
       ROUND(AVG((salary_min + salary_max) / 2), 0)
       AS average_salary_inr
FROM jobs
GROUP BY job_title
ORDER BY average_salary_inr DESC;

-- 9. Highest salary jobs
SELECT job_title, salary_min, salary_max
FROM jobs
ORDER BY salary_max DESC
LIMIT 10;

-- 10. Entry-level jobs (maximum 1 year minimum experience)
SELECT job_title, experience_min, experience_max
FROM jobs
WHERE experience_min <= 1
ORDER BY experience_min;

-- 11. Jobs requiring 3 or more minimum years
SELECT job_title, COUNT(*) AS job_count
FROM jobs
WHERE experience_min >= 3
GROUP BY job_title
ORDER BY job_count DESC;

-- 12. Most demanded skills
SELECT s.skill_name, COUNT(*) AS demand_count
FROM job_skills js
JOIN skills s ON js.skill_id = s.skill_id
GROUP BY s.skill_name
ORDER BY demand_count DESC
LIMIT 15;

-- 13. Skill demand by category
SELECT s.skill_category, COUNT(*) AS requirements
FROM job_skills js
JOIN skills s ON js.skill_id = s.skill_id
GROUP BY s.skill_category
ORDER BY requirements DESC;

-- 14. Skills required for Data Analyst roles
SELECT DISTINCT s.skill_name
FROM jobs j
JOIN job_skills js ON j.job_id = js.job_id
JOIN skills s ON js.skill_id = s.skill_id
WHERE j.job_title LIKE '%Data Analyst%'
ORDER BY s.skill_name;

-- 15. Skills required for AI/ML roles
SELECT DISTINCT s.skill_name
FROM jobs j
JOIN job_skills js ON j.job_id = js.job_id
JOIN skills s ON js.skill_id = s.skill_id
WHERE j.job_title LIKE '%AI%'
   OR j.job_title LIKE '%ML Engineer%'
   OR j.job_title LIKE '%Machine Learning%'
ORDER BY s.skill_name;

-- 16. Jobs requiring both SQL and Python
SELECT j.job_id, j.job_title
FROM jobs j
JOIN job_skills js ON j.job_id = js.job_id
JOIN skills s ON js.skill_id = s.skill_id
WHERE s.skill_name IN ('SQL', 'Python')
GROUP BY j.job_id, j.job_title
HAVING COUNT(DISTINCT s.skill_name) = 2;

-- 17. Jobs requiring Power BI
SELECT COUNT(DISTINCT j.job_id) AS power_bi_jobs
FROM jobs j
JOIN job_skills js ON j.job_id = js.job_id
JOIN skills s ON js.skill_id = s.skill_id
WHERE s.skill_name = 'Power BI';

-- 18. Jobs requiring Machine Learning
SELECT COUNT(DISTINCT j.job_id) AS ml_jobs
FROM jobs j
JOIN job_skills js ON j.job_id = js.job_id
JOIN skills s ON js.skill_id = s.skill_id
WHERE s.skill_name = 'Machine Learning';

-- 19. Number of skills required per job
SELECT j.job_id, j.job_title,
       COUNT(js.skill_id) AS skill_count
FROM jobs j
LEFT JOIN job_skills js ON j.job_id = js.job_id
GROUP BY j.job_id, j.job_title
ORDER BY skill_count DESC;

-- 20. Average salary by work mode
SELECT work_mode,
       ROUND(AVG((salary_min + salary_max) / 2), 0)
       AS average_salary_inr
FROM jobs
GROUP BY work_mode
ORDER BY average_salary_inr DESC;

-- 21. Average salary by city
SELECT l.city,
       ROUND(AVG((j.salary_min + j.salary_max) / 2), 0)
       AS average_salary_inr
FROM jobs j
JOIN locations l ON j.location_id = l.location_id
GROUP BY l.city
ORDER BY average_salary_inr DESC;

-- 22. Active vs closed postings
SELECT status, COUNT(*) AS total_postings
FROM job_postings
GROUP BY status;

-- 23. Posting sources by number of jobs
SELECT source, COUNT(*) AS total_jobs
FROM job_postings
GROUP BY source
ORDER BY total_jobs DESC;

-- 24. Applications by posting source
SELECT source,
       SUM(application_count) AS total_applications,
       ROUND(AVG(application_count), 1) AS avg_applications
FROM job_postings
GROUP BY source
ORDER BY total_applications DESC;

-- 25. Most applied-to job records
SELECT j.job_title, c.company_name,
       jp.application_count, jp.source
FROM job_postings jp
JOIN jobs j ON jp.job_id = j.job_id
JOIN companies c ON j.company_id = c.company_id
ORDER BY jp.application_count DESC
LIMIT 10;

-- 26. Monthly job posting trend
SELECT DATE_FORMAT(posting_date, '%Y-%m') AS posting_month,
       COUNT(*) AS total_postings
FROM job_postings
GROUP BY DATE_FORMAT(posting_date, '%Y-%m')
ORDER BY posting_month;

-- 27. Jobs posted by month and work mode
SELECT DATE_FORMAT(j.posted_date, '%Y-%m') AS posting_month,
       j.work_mode, COUNT(*) AS total_jobs
FROM jobs j
GROUP BY DATE_FORMAT(j.posted_date, '%Y-%m'), j.work_mode
ORDER BY posting_month, total_jobs DESC;

-- 28. Companies with average salary above ₹10 LPA
SELECT c.company_name,
       ROUND(AVG((j.salary_min + j.salary_max) / 2), 0)
       AS average_salary_inr
FROM jobs j
JOIN companies c ON j.company_id = c.company_id
GROUP BY c.company_id, c.company_name
HAVING AVG((j.salary_min + j.salary_max) / 2) > 1000000
ORDER BY average_salary_inr DESC;

-- 29. Skill combinations: SQL and Python
SELECT
    SUM(CASE WHEN s.skill_name = 'SQL' THEN 1 ELSE 0 END)
       AS sql_requirements,
    SUM(CASE WHEN s.skill_name = 'Python' THEN 1 ELSE 0 END)
       AS python_requirements
FROM job_skills js
JOIN skills s ON js.skill_id = s.skill_id;

-- 30. Job titles with highest average applications
SELECT j.job_title,
       ROUND(AVG(jp.application_count), 1) AS avg_applications
FROM jobs j
JOIN job_postings jp ON j.job_id = jp.job_id
GROUP BY j.job_title
ORDER BY avg_applications DESC;

-- 31. Rank jobs by maximum salary using a window function
SELECT job_title, salary_max,
       RANK() OVER (ORDER BY salary_max DESC) AS salary_rank
FROM jobs;

-- 32. Rank skills by demand using a CTE
WITH skill_demand AS (
    SELECT s.skill_name, COUNT(*) AS demand_count
    FROM job_skills js
    JOIN skills s ON js.skill_id = s.skill_id
    GROUP BY s.skill_name
)
SELECT skill_name, demand_count,
       DENSE_RANK() OVER (ORDER BY demand_count DESC) AS demand_rank
FROM skill_demand
ORDER BY demand_rank, skill_name;

-- 33. Salary band classification using CASE
SELECT job_title,
       ROUND((salary_min + salary_max) / 2, 0) AS avg_salary,
       CASE
           WHEN (salary_min + salary_max) / 2 < 600000
               THEN 'Below 6 LPA'
           WHEN (salary_min + salary_max) / 2 < 1200000
               THEN '6-12 LPA'
           ELSE '12 LPA and above'
       END AS salary_band
FROM jobs;

-- 34. Jobs with above-average maximum salary (subquery)
SELECT job_title, salary_max
FROM jobs
WHERE salary_max > (SELECT AVG(salary_max) FROM jobs)
ORDER BY salary_max DESC;

-- 35. Check jobs with no skill mappings
SELECT j.job_id, j.job_title
FROM jobs j
LEFT JOIN job_skills js ON j.job_id = js.job_id
WHERE js.job_id IS NULL;

-- 36. Complete job listing with company, city and salary
SELECT j.job_id, j.job_title, c.company_name,
       l.city, j.work_mode,
       j.experience_min, j.experience_max,
       j.salary_min, j.salary_max
FROM jobs j
JOIN companies c ON j.company_id = c.company_id
JOIN locations l ON j.location_id = l.location_id
ORDER BY j.job_id;

-- 37. Skill gap starter: skills required for Data Analyst jobs
-- Compare this list with the skills you already know.
SELECT s.skill_name, COUNT(*) AS number_of_jobs
FROM jobs j
JOIN job_skills js ON j.job_id = js.job_id
JOIN skills s ON js.skill_id = s.skill_id
WHERE j.job_title LIKE '%Data Analyst%'
GROUP BY s.skill_name
ORDER BY number_of_jobs DESC;

-- 38. Job postings by status and source
SELECT source, status, COUNT(*) AS posting_count
FROM job_postings
GROUP BY source, status
ORDER BY source, status;

-- 39. Jobs with the largest number of required skills
SELECT j.job_title, j.job_id,
       COUNT(js.skill_id) AS required_skills
FROM jobs j
LEFT JOIN job_skills js ON j.job_id = js.job_id
GROUP BY j.job_id, j.job_title
ORDER BY required_skills DESC
LIMIT 10;

-- 40. Summary: jobs, average salary and applications by role
SELECT j.job_title,
       COUNT(DISTINCT j.job_id) AS total_jobs,
       ROUND(AVG((j.salary_min + j.salary_max) / 2), 0)
           AS average_salary_inr,
       ROUND(AVG(jp.application_count), 1)
           AS average_applications
FROM jobs j
JOIN job_postings jp ON j.job_id = jp.job_id
GROUP BY j.job_title
ORDER BY total_jobs DESC;


SELECT COUNT(*) AS total_companies FROM companies;

SELECT COUNT(*) AS total_locations FROM locations;

SELECT COUNT(*) AS total_skills FROM skills;

SELECT COUNT(*) AS total_jobs FROM jobs;

SELECT COUNT(*) AS total_job_skill_links FROM job_skills;

SELECT COUNT(*) AS total_postings FROM job_postings;