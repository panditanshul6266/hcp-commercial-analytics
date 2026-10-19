# Power BI / Excel extension

No PBIX or XLSX is included. These are reproducible setup instructions.

Import the three source CSVs. Relate affiliation[hcp_id] one-to-many to sales[hcp_id] and alerts[hcp_id] with single-direction filters. Use affiliation fields for slicers. For the quickest report, import hcp_prioritization.csv as a separate flat analysis table.

Suggested visuals: segment bar chart, region slicer, HCP priority table, pre/post brand Rx cards, and alerted/contacted/post-prescriber funnel.

Example DAX on the flat table:
```dax
Pre Rx = SUM(hcp_prioritization[pre_rx])
Post Rx = SUM(hcp_prioritization[post_rx])
Observed Lift % = DIVIDE([Post Rx] - [Pre Rx], [Pre Rx])
HCP Count = DISTINCTCOUNT(hcp_prioritization[hcp_id])
```
Format Observed Lift % as percentage. In Excel, import the output CSV and use a PivotTable for region and segment. Do not call pre/post lift campaign-attributable ROI: there is no control group, spend or profit data.
