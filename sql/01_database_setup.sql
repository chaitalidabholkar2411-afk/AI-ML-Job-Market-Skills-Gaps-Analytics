
-- =====================================================
-- PROJECT: AI/ML JOB MARKET & SKILL GAP ANALYTICS
-- MYSQL 8.0+
-- STEP 1: DATABASE + TABLES
-- =====================================================

CREATE DATABASE ai_ml_job_markets;
USE ai_ml_job_markets;

CREATE TABLE companies (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(150) NOT NULL,
    industry VARCHAR(100),
    company_size VARCHAR(50)
);

CREATE TABLE locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    country VARCHAR(100) DEFAULT 'India'
);

CREATE TABLE skills (
    skill_id INT PRIMARY KEY AUTO_INCREMENT,
    skill_name VARCHAR(100) NOT NULL UNIQUE,
    skill_category VARCHAR(100)
);

CREATE TABLE jobs (
    job_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    location_id INT NOT NULL,
    job_title VARCHAR(150) NOT NULL,
    experience_min INT,
    experience_max INT,
    salary_min DECIMAL(12,2),
    salary_max DECIMAL(12,2),
    work_mode VARCHAR(30),
    posted_date DATE,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE job_skills (
    job_id INT NOT NULL,
    skill_id INT NOT NULL,
    required_level VARCHAR(30),
    PRIMARY KEY (job_id, skill_id),
    FOREIGN KEY (job_id) REFERENCES jobs(job_id)
        ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id)
        ON DELETE CASCADE
);

CREATE TABLE job_postings (
    posting_id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT NOT NULL,
    source VARCHAR(100),
    posting_date DATE,
    application_count INT DEFAULT 0,
    status VARCHAR(30),
    FOREIGN KEY (job_id) REFERENCES jobs(job_id)
        ON DELETE CASCADE
);

-- =====================================================
-- STEP 2: INSERT 25 COMPANIES
-- =====================================================

INSERT INTO companies (company_name, industry, company_size)
VALUES
('Tata Consultancy Services','IT Services','Large'),
('Infosys','IT Services','Large'),
('Accenture','Consulting','Large'),
('Deloitte','Consulting','Large'),
('Capgemini','IT Services','Large'),
('Cognizant','IT Services','Large'),
('Wipro','IT Services','Large'),
('HCLTech','IT Services','Large'),
('IBM','Technology','Large'),
('Microsoft','Technology','Large'),
('Amazon','Technology','Large'),
('Google','Technology','Large'),
('Fractal Analytics','Analytics','Large'),
('Tiger Analytics','Analytics','Large'),
('Mu Sigma','Analytics','Large'),
('Zensar Technologies','IT Services','Large'),
('Persistent Systems','IT Services','Large'),
('LTIMindtree','IT Services','Large'),
('Freshworks','Software','Medium'),
('PhonePe','FinTech','Large'),
('Razorpay','FinTech','Medium'),
('Swiggy','E-commerce','Large'),
('Zomato','E-commerce','Large'),
('Myntra','E-commerce','Large'),
('Jio Platforms','Technology','Large');

-- =====================================================
-- STEP 3: INSERT 15 LOCATIONS
-- =====================================================

INSERT INTO locations (city, state, country)
VALUES
('Mumbai','Maharashtra','India'),
('Pune','Maharashtra','India'),
('Bengaluru','Karnataka','India'),
('Hyderabad','Telangana','India'),
('Chennai','Tamil Nadu','India'),
('New Delhi','Delhi','India'),
('Gurugram','Haryana','India'),
('Noida','Uttar Pradesh','India'),
('Kolkata','West Bengal','India'),
('Ahmedabad','Gujarat','India'),
('Navi Mumbai','Maharashtra','India'),
('Thane','Maharashtra','India'),
('Jaipur','Rajasthan','India'),
('Indore','Madhya Pradesh','India'),
('Kochi','Kerala','India');

-- =====================================================
-- STEP 4: INSERT 41 SKILLS
-- =====================================================

INSERT INTO skills (skill_name, skill_category)
VALUES
('Python','Programming'),
('R','Programming'),
('Java','Programming'),
('C++','Programming'),
('SQL','Database'),
('MySQL','Database'),
('PostgreSQL','Database'),
('MongoDB','Database'),
('Excel','Analytics'),
('Power Query','Analytics'),
('Pandas','Python Library'),
('NumPy','Python Library'),
('Matplotlib','Visualization'),
('Power BI','Visualization'),
('Tableau','Visualization'),
('Machine Learning','AI/ML'),
('Deep Learning','AI/ML'),
('TensorFlow','AI/ML'),
('PyTorch','AI/ML'),
('Scikit-learn','AI/ML'),
('Natural Language Processing','AI/ML'),
('Computer Vision','AI/ML'),
('Statistics','Analytics'),
('Regression','Analytics'),
('Hypothesis Testing','Analytics'),
('AWS','Cloud'),
('Microsoft Azure','Cloud'),
('Google Cloud','Cloud'),
('Apache Spark','Big Data'),
('Hadoop','Big Data'),
('ETL','Data Engineering'),
('Data Warehousing','Data Engineering'),
('Airflow','Data Engineering'),
('Git','Development Tools'),
('GitHub','Development Tools'),
('Docker','Development Tools'),
('Generative AI','AI/ML'),
('Large Language Models','AI/ML'),
('Prompt Engineering','AI/ML'),
('Data Visualization','Visualization'),
('dbt','Data Engineering');

-- =====================================================
-- STEP 5A: GENERATE 100 JOB RECORDS
-- Salary values are annual INR; 700000 = ₹7 LPA
-- =====================================================

INSERT INTO jobs
(company_id, location_id, job_title, experience_min,
 experience_max, salary_min, salary_max, work_mode, posted_date)

SELECT
    MOD(n - 1, 25) + 1,
    MOD(n - 1, 15) + 1,

    CASE MOD(n - 1, 20)
        WHEN 0 THEN 'Data Analyst'
        WHEN 1 THEN 'Senior Data Analyst'
        WHEN 2 THEN 'Product Data Analyst'
        WHEN 3 THEN 'Data Scientist'
        WHEN 4 THEN 'Senior Data Scientist'
        WHEN 5 THEN 'Machine Learning Engineer'
        WHEN 6 THEN 'ML Engineer'
        WHEN 7 THEN 'Senior ML Engineer'
        WHEN 8 THEN 'AI/ML Engineer'
        WHEN 9 THEN 'AI Engineer'
        WHEN 10 THEN 'AI Research Engineer'
        WHEN 11 THEN 'AI Research Scientist'
        WHEN 12 THEN 'Business Intelligence Analyst'
        WHEN 13 THEN 'Senior BI Analyst'
        WHEN 14 THEN 'BI Developer'
        WHEN 15 THEN 'Power BI Developer'
        WHEN 16 THEN 'Business Analyst'
        WHEN 17 THEN 'Data Engineer'
        WHEN 18 THEN 'Product Analyst'
        ELSE 'Analytics Engineer'
    END,

    CASE
        WHEN MOD(n - 1, 20) IN (1,4,7,11,13) THEN 4
        WHEN MOD(n - 1, 20) IN (5,6,8,9,10,17,19) THEN 2
        ELSE 0
    END,

    CASE
        WHEN MOD(n - 1, 20) IN (1,4,7,11,13) THEN 8
        WHEN MOD(n - 1, 20) IN (5,6,8,9,10,17,19) THEN 5
        ELSE 3
    END,

    CASE
        WHEN MOD(n - 1, 20) IN (1,4,7,11,13) THEN 1000000
        WHEN MOD(n - 1, 20) IN (5,6,8,9,10,17,19) THEN 700000
        ELSE 400000
    END,

    CASE
        WHEN MOD(n - 1, 20) IN (1,4,7,11,13) THEN 2200000
        WHEN MOD(n - 1, 20) IN (5,6,8,9,10,17,19) THEN 1800000
        ELSE 1000000
    END,

    CASE MOD(n, 3)
        WHEN 0 THEN 'Remote'
        WHEN 1 THEN 'Hybrid'
        ELSE 'Onsite'
    END,

    DATE_ADD('2026-01-05', INTERVAL (n - 1) * 3 DAY)

FROM (
    SELECT
        ones.d + tens.d * 10 + 1 AS n
    FROM
        (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2
         UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
         SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7
         UNION ALL SELECT 8 UNION ALL SELECT 9) ones
    CROSS JOIN
        (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2
         UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
         SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7
         UNION ALL SELECT 8 UNION ALL SELECT 9) tens
) numbers
WHERE n <= 100;

-- =====================================================
-- STEP 5B: MAP JOBS TO REQUIRED SKILLS
-- Each job receives multiple skills based on its title.
-- =====================================================

INSERT INTO job_skills (job_id, skill_id, required_level)
SELECT DISTINCT
    j.job_id,
    s.skill_id,
    CASE
        WHEN s.skill_name IN
        ('Machine Learning','Deep Learning','TensorFlow',
         'PyTorch','AWS','Microsoft Azure','Google Cloud',
         'Apache Spark','Generative AI','Large Language Models')
        THEN 'Advanced'
        ELSE 'Intermediate'
    END
FROM jobs j
JOIN skills s
ON
(
    (
        j.job_title LIKE '%Data Analyst%'
        AND s.skill_name IN
        ('SQL','Python','Excel','Power BI','Statistics',
         'Pandas','NumPy','Matplotlib','Git','Data Visualization')
    )
    OR
    (
        j.job_title LIKE '%Data Scientist%'
        AND s.skill_name IN
        ('Python','SQL','Machine Learning','Statistics',
         'Pandas','NumPy','Scikit-learn','Regression',
         'Power BI','Git')
    )
    OR
    (
        (j.job_title LIKE '%ML Engineer%'
         OR j.job_title LIKE '%Machine Learning Engineer%'
         OR j.job_title LIKE '%AI/ML Engineer%')
        AND s.skill_name IN
        ('Python','SQL','Machine Learning','Deep Learning',
         'TensorFlow','PyTorch','Scikit-learn','Git',
         'Docker','AWS')
    )
    OR
    (
        j.job_title LIKE '%AI Engineer%'
        AND s.skill_name IN
        ('Python','SQL','Machine Learning','Deep Learning',
         'TensorFlow','PyTorch','Natural Language Processing',
         'Generative AI','Large Language Models',
         'Git','Docker','AWS')
    )
    OR
    (
        j.job_title LIKE '%AI Research%'
        AND s.skill_name IN
        ('Python','Machine Learning','Deep Learning',
         'TensorFlow','PyTorch','Natural Language Processing',
         'Computer Vision','Statistics','Generative AI',
         'Large Language Models')
    )
    OR
    (
        j.job_title LIKE '%Data Engineer%'
        AND s.skill_name IN
        ('Python','SQL','MySQL','PostgreSQL','Apache Spark',
         'Hadoop','ETL','Data Warehousing','Airflow',
         'AWS','Docker','Git','dbt')
    )
    OR
    (
        (j.job_title LIKE '%BI Analyst%'
         OR j.job_title LIKE '%Business Intelligence Analyst%'
         OR j.job_title LIKE '%BI Developer%'
         OR j.job_title LIKE '%Power BI Developer%')
        AND s.skill_name IN
        ('SQL','Excel','Power BI','Tableau','Power Query',
         'Statistics','Git','Data Visualization')
    )
    OR
    (
        (j.job_title LIKE '%Business Analyst%'
         OR j.job_title LIKE '%Product Analyst%')
        AND s.skill_name IN
        ('SQL','Excel','Power BI','Tableau','Statistics',
         'Python','Power Query','Data Visualization')
    )
    OR
    (
        j.job_title LIKE '%Analytics Engineer%'
        AND s.skill_name IN
        ('SQL','Python','MySQL','PostgreSQL','ETL',
         'Data Warehousing','Airflow','dbt','Git','AWS')
    )
);

-- =====================================================
-- STEP 5C: ADD POSTING DETAILS FOR ALL 100 JOBS
-- Sources and application counts are synthetic.
-- =====================================================

INSERT INTO job_postings
(job_id, source, posting_date, application_count, status)
SELECT
    j.job_id,
    CASE MOD(j.job_id, 4)
        WHEN 1 THEN 'LinkedIn'
        WHEN 2 THEN 'Naukri'
        WHEN 3 THEN 'Indeed'
        ELSE 'Company Website'
    END,
    j.posted_date,
    50 + MOD(j.job_id * 13, 151),
    CASE
        WHEN MOD(j.job_id, 3) = 0 THEN 'Closed'
        ELSE 'Active'
    END
FROM jobs j;

-- =====================================================
-- STEP 6: VERIFY ALL TABLES
-- =====================================================

SELECT 'companies' AS table_name, COUNT(*) AS total_rows
FROM companies
UNION ALL
SELECT 'locations', COUNT(*) FROM locations
UNION ALL
SELECT 'skills', COUNT(*) FROM skills
UNION ALL
SELECT 'jobs', COUNT(*) FROM jobs
UNION ALL
SELECT 'job_skills', COUNT(*) FROM job_skills
UNION ALL
SELECT 'job_postings', COUNT(*) FROM job_postings;

USE ai_ml_job_market;

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












