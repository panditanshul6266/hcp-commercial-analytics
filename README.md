# HCP Commercial Analytics

A reproducible SQL portfolio case study for physician segmentation and sales-rep prioritization using **240 synthetic HCPs**, three relational datasets, and equal pre/post windows.

**All records are fictional. No patient or real physician data. Results are simulated and do not establish campaign effectiveness or actual ROI.**

## Run
```sh
python run_analysis.py
```
Python 3 standard library only. This loads an in-memory SQLite database, runs quality checks and CTE analysis, and recreates `hcp_prioritization.csv` and `summary.json`. Open `dashboard.html` for the included static report. The SQL uses MySQL 8-compatible CTEs; MySQL execution has not been tested. For MySQL, create tables with `schema.sql`, import CSVs through Workbench, then run `analysis.sql`.

## Data model
| File | Grain | Rows |
|---|---|---|
| affiliation.csv | One HCP with region, specialty and rep | 240 |
| sales.csv | HCP-month, Jan-Jun 2026 | 1,440 |
| alerts.csv | One outreach alert | 160 |

## Method
- Pre period: Jan-Mar 2026; post: Apr-Jun 2026. Brand Rx is a synthetic count, not revenue.
- New Starter: zero pre Rx and positive post Rx. Non-Responder: zero post Rx (regardless of contact; a descriptive sales segment). Grower: positive post Rx greater than pre. Remaining HCPs: Decliner / Stable.
- Observed lift: `(post-pre)/pre`; undefined for zero baseline, represented as NULL.
- Competitor share: competitor post Rx divided by combined post Rx; a descriptive opportunity proxy.
- Priority score: 30 points for competitor dominance, 25 for brand decline, 20 for current prescribing and 15 for no contact. Ties break by competitor volume and HCP ID. This heuristic ranks opportunities, not clinical suitability or proven financial returns.
- Funnel: all HCPs -> alerted -> contacted -> contacted with post-period prescriptions. This is an association, not confirmed response attribution. Alerts are aggregated before joining to prevent sales fan-out.

## Files and validation
`data_quality.sql` checks duplicates, negative counts, orphan sales, incomplete six-month histories and invalid contact flags. Python enables FK enforcement and asserts one final row per HCP. `powerbi-guide.md` documents optional Excel/Power BI setup; no native Excel workbook or Power BI report is claimed.

## Limitations
Synthetic random data (seed 42); no real-world findings. No control group, campaign spend, margins, causality, or measured ROI. A real deployment needs validated business rules, privacy controls, stable IDs and a properly designed evaluation.

## Honest CV bullet
Built a reproducible SQL analytics case study across three synthetic relational datasets covering 240 HCPs; implemented CTE-based pre/post analysis, physician segmentation, outreach funnels and a heuristic prioritization report.
