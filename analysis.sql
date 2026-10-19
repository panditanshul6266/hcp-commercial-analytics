-- Portable CTEs: MySQL 8+ and SQLite. Equal three-month windows.
WITH rx AS (
 SELECT hcp_id,
 SUM(CASE WHEN month<'2026-04-01' THEN brand_rx ELSE 0 END) AS pre_rx,
 SUM(CASE WHEN month>='2026-04-01' THEN brand_rx ELSE 0 END) AS post_rx,
 SUM(CASE WHEN month>='2026-04-01' THEN competitor_rx ELSE 0 END) AS competitor_post
 FROM sales GROUP BY hcp_id
), activity AS (
 SELECT hcp_id,COUNT(*) AS alert_count,MAX(contacted) AS contacted FROM alerts GROUP BY hcp_id
), scored AS (
 SELECT a.*,r.pre_rx,r.post_rx,r.competitor_post,
 COALESCE(t.alert_count,0) AS alert_count,COALESCE(t.contacted,0) AS contacted,
 CASE WHEN pre_rx=0 AND post_rx>0 THEN 'New Starter'
      WHEN post_rx=0 THEN 'Non-Responder'
      WHEN post_rx>pre_rx THEN 'Grower' ELSE 'Decliner / Stable' END AS segment,
 ROUND(100.0*(post_rx-pre_rx)/NULLIF(pre_rx,0),2) AS lift_pct,
 ROUND(100.0*competitor_post/NULLIF(post_rx+competitor_post,0),2) AS competitor_share_pct,
 -- Heuristic opportunity score, not a validated ROI model.
 (CASE WHEN competitor_post>post_rx THEN 30 ELSE 0 END +
 CASE WHEN pre_rx>post_rx THEN 25 ELSE 0 END +
 CASE WHEN post_rx>0 THEN 20 ELSE 0 END +
 CASE WHEN COALESCE(t.contacted,0)=0 THEN 15 ELSE 0 END) AS priority_score
 FROM affiliation a JOIN rx r ON a.hcp_id=r.hcp_id LEFT JOIN activity t ON a.hcp_id=t.hcp_id
)
SELECT * FROM scored ORDER BY priority_score DESC,competitor_post DESC,hcp_id;
