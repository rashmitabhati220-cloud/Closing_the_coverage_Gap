/* =====================================================================
   Closing the Coverage Gap — SQL analysis
   Heart-attack-risk dataset, ~10,000 patients, India
   Tool: SQLite / DB Browser. Table name: project2
   Flags (0/1): Health_Insurance 1=insured | Healthcare_Access 1=good
                Heart_Attack_History 1=prior attack | Heart_Attack_Risk 1=flagged
   ===================================================================== */

-- Query 1: Overview
SELECT
    COUNT(*)                                                 AS total_patients,
    ROUND(100.0 * AVG(Health_Insurance), 1)                 AS pct_insured,
    ROUND(100.0 * AVG(Healthcare_Access), 1)                AS pct_good_access,
    ROUND(100.0 * AVG(CASE WHEN Emergency_Response_Time < 60
                           THEN 1 ELSE 0 END), 1)           AS pct_fast_under_60
FROM project2;

-- Query 2: Coverage funnel
SELECT 'Total patient population' AS stage, 100.0 AS share UNION ALL
SELECT 'Have health insurance', ROUND(100.0*AVG(Health_Insurance),1) FROM project2 UNION ALL
SELECT 'Have good healthcare access', ROUND(100.0*AVG(Healthcare_Access),1) FROM project2 UNION ALL
SELECT 'Reached fast (under 60)',
       ROUND(100.0*AVG(CASE WHEN Emergency_Response_Time<60 THEN 1 ELSE 0 END),1) FROM project2;

-- Query 3: Coverage & reach by state
SELECT State_Name, COUNT(*) AS patients,
       ROUND(100.0*AVG(Health_Insurance),1)       AS insured_pct,
       ROUND(100.0*AVG(Healthcare_Access),1)      AS good_access_pct,
       ROUND(AVG(Emergency_Response_Time),1)      AS avg_response,
       ROUND(100.0*AVG(Air_Pollution_Exposure),1) AS pollution_pct,
       ROUND(100.0*AVG(Heart_Attack_History),1)   AS prior_attack_pct
FROM project2
GROUP BY State_Name
ORDER BY good_access_pct ASC;

-- Query 4: Bottom 10 states by healthcare access
SELECT State_Name, ROUND(100.0*AVG(Healthcare_Access),1) AS good_access_pct
FROM project2
GROUP BY State_Name
ORDER BY good_access_pct ASC
LIMIT 10;

-- Query 5: Emergency response-time bands
WITH banded AS (
    SELECT CASE
             WHEN Emergency_Response_Time < 60  THEN 'Under 60 (fast)'
             WHEN Emergency_Response_Time < 120 THEN '60-120'
             WHEN Emergency_Response_Time < 240 THEN '120-240'
             ELSE 'Over 240 (critical)'
           END AS response_band
    FROM project2
)
SELECT response_band, COUNT(*) AS patients,
       ROUND(100.0*COUNT(*)/(SELECT COUNT(*) FROM project2),1) AS share_pct
FROM banded
GROUP BY response_band
ORDER BY MIN(CASE response_band
              WHEN 'Under 60 (fast)' THEN 1 WHEN '60-120' THEN 2
              WHEN '120-240' THEN 3 ELSE 4 END);

-- Query 6: Insurance & access by income quartile
WITH q AS (
    SELECT Health_Insurance, Healthcare_Access,
           NTILE(4) OVER (ORDER BY Annual_Income) AS income_quartile
    FROM project2
)
SELECT 'Q'||income_quartile AS income_quartile,
       ROUND(100.0*AVG(Health_Insurance),1)  AS insured_pct,
       ROUND(100.0*AVG(Healthcare_Access),1) AS good_access_pct
FROM q
GROUP BY income_quartile
ORDER BY income_quartile;

-- Query 7: High-need / double-gap headline
WITH flagged AS (
    SELECT CASE WHEN Heart_Attack_History=1 OR Heart_Attack_Risk=1
                THEN 1 ELSE 0 END AS high_need,
           Health_Insurance, Healthcare_Access
    FROM project2
)
SELECT COUNT(*) AS total_patients,
       SUM(high_need) AS high_need_patients,
       ROUND(100.0*AVG(high_need),1) AS high_need_pct,
       ROUND(100.0*SUM(CASE WHEN high_need=1 AND Health_Insurance=0 THEN 1 ELSE 0 END)/SUM(high_need),1) AS uninsured_among_high_need_pct,
       ROUND(100.0*SUM(CASE WHEN high_need=1 AND Healthcare_Access=0 THEN 1 ELSE 0 END)/SUM(high_need),1) AS poor_access_among_high_need_pct,
       SUM(CASE WHEN high_need=1 AND Health_Insurance=0 AND Healthcare_Access=0 THEN 1 ELSE 0 END) AS both_gaps_count,
       ROUND(100.0*SUM(CASE WHEN high_need=1 AND Health_Insurance=0 AND Healthcare_Access=0 THEN 1 ELSE 0 END)/SUM(high_need),1) AS both_gaps_pct_of_high_need
FROM flagged;
