<img width="1083" height="525" alt="Screenshot 2026-06-25 at 10 11 24 PM" src="https://github.com/user-attachments/assets/e27892ef-7a17-4948-bf51-dbc475d7589c" />

# Closing the Coverage Gap

Analysis of insurance coverage, healthcare access, and emergency response among ~10,000 heart-attack-risk patients across 28 Indian states.

## Business Question
Among patients at risk of a heart attack, how many actually have the insurance, healthcare access, and fast emergency response they would need — and who is being left out?

## Dataset
- Heart-attack-risk dataset (India), ~10,000 rows, 26 columns, one row per patient.
- No date column — analysis is cross-sectional (by state, income, risk level).

## Tools Used
- Google Sheets / Excel — cleaning and pivot-table analysis
- SQL (SQLite / DB Browser) — data extraction and aggregation
- Tableau Public — dashboard and visualisation

## Key Findings
1. **Two-thirds of at-risk patients are uninsured** — only 34.5% have health insurance.
2. **Access is even thinner** — just 31.1% have reliable healthcare access.
3. **Emergency response is the weakest link** — 41.5% fall into the slowest "critical" band (>240); only 12.3% are reached fastest.
4. **The gap is structural, not about money** — coverage is flat (~34% insured, ~31% access) across all four income quartiles, including the richest.
5. **The highest-need patients are the least covered** — of the 40.7% flagged high-need (prior attack or risk), 66% are uninsured, ~70% have poor access, and 45.5% (1,852 patients) face both gaps at once.
6. **Geography concentrates it** — lowest access in Goa (26.2%), Madhya Pradesh (27.6%), Himachal Pradesh & Mizoram (27.7%).

**Recommendation:** a coverage-and-reach problem operations can own — target the ~1,850 high-need, double-gap patients in the lowest-access states rather than spreading effort evenly.

## Live Dashboard
[View the interactive dashboard on Tableau Public →](https://public.tableau.com/app/profile/rashmita.bhati/viz/Closing_the_coverage_Gap-Heart_attack_risk_in_India/Closing_the_coverage_Gap-HeartattackriskinIndia)

## SQL
All analysis queries are in `coverage_gap_analysis.sql` — overview, coverage funnel, coverage by state, bottom-10 access states, response-time bands, income quartiles, and the high-need / double-gap headline. They reproduce every figure above.
