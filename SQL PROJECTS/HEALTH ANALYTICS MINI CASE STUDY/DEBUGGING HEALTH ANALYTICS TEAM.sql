-- DEBUGGING HEALTH ANALYTICS TEAM SQL QUERIES

-- 1. How many unique users exist in the logs dataset?

-- Wrong script
SELECT
  COUNT DISTINCT user_id
FROM health.user_logs;

-- Corrected Script
SELECT
  COUNT (DISTINCT id) unique_users
FROM health.user_logs;

-- for questions 2-8 we created a temporary table

-- Wrong script
DROP TABLE IF EXISTS user_measure_count;
CREATE TEMP TABLE user_measure_cout
SELECT
    id,
    COUNT(*) AS measure_count,
    COUNT(DISTINCT measure) as unique_measures
  FROM health.user_logs
  GROUP BY 1;
  
-- Corrected script
DROP TABLE IF EXISTS user_measure_count;
CREATE TEMP TABLE user_measure_count AS
SELECT
    id,
    COUNT(*) AS measure_count,
    COUNT(DISTINCT measure) as unique_measures
  FROM health.user_logs
  GROUP BY 1; 

-- 2. How many total measurements do we have per user on average?

-- Wrong script
SELECT
  ROUND(MEAN(measure_count))
FROM user_measure_count;

-- Corrected script
SELECT
  ROUND(AVG(measure_count)) average_total_measurement
FROM user_measure_count;

-- 3. What about the median number of measurements per user?

-- Wrong Script
SELECT
  PERCENTILE_CONTINUOUS(0.5) WITHIN GROUP (ORDER BY id) AS median_value
FROM user_measure_count;

-- Corrected Script
SELECT
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY measure_count) AS median_value
FROM user_measure_count;

-- 4. How many users have 3 or more measurements?

-- Wrong Script
SELECT
  COUNT(*)
FROM user_measure_count
HAVING measure >= 3;

-- Corrected Script
SELECT
  COUNT(*) user_count
FROM user_measure_count
WHERE measure_count >= 3;

-- 5. How many users have 1,000 or more measurements?

-- Wrong Script
SELECT
  SUM(id)
FROM user_measure_count
WHERE measure_count >= 1000;

-- Corrected Script
SELECT
  COUNT(*) user_count
FROM user_measure_count
WHERE measure_count >= 1000;

-- 6. Have logged blood glucose measurements?

--Wrong Script
SELECT
  COUNT DISTINCT id
FROM health.user_logs
WHERE measure is 'blood_sugar';

--Corrected Script
SELECT
  COUNT(DISTINCT id) user_count
FROM health.user_logs
WHERE measure = 'blood_glucose';

-- 7. Have at least 2 types of measurements?

-- Wrong Script
SELECT
  COUNT(*)
FROM user_measure_count
WHERE COUNT(DISTINCT measures) >= 2;

-- Corrected Script
SELECT
  COUNT(*) user_count
FROM user_measure_count
WHERE unique_measures >= 2;

-- 8. Have all 3 measures - blood glucose, weight and blood pressure?

-- Wrong Script
SELECT
  COUNT(*)
FROM usr_measure_count
WHERE unique_measures = 3;

-- Corrected Script
SELECT
  COUNT(*) user_count
FROM user_measure_count
WHERE unique_measures = 3;

-- 9.  What is the median systolic/diastolic blood pressure values?

-- Wrong Script
SELECT
  PERCENTILE_CONT(0.5) WITHIN (ORDER BY systolic) AS median_systolic
  PERCENTILE_CONT(0.5) WITHIN (ORDER BY diastolic) AS median_diastolic
FROM health.user_logs
WHERE measure is blood_pressure;

-- Corrected Script
SELECT
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY systolic) AS median_systolic,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY diastolic) AS median_diastolic
FROM health.user_logs
WHERE measure = 'blood_pressure';