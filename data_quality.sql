-- Each query should return zero rows.
SELECT hcp_id,month,COUNT(*) FROM sales GROUP BY hcp_id,month HAVING COUNT(*)>1;
SELECT * FROM sales WHERE brand_rx<0 OR competitor_rx<0;
SELECT s.hcp_id FROM sales s LEFT JOIN affiliation a ON a.hcp_id=s.hcp_id WHERE a.hcp_id IS NULL;
SELECT hcp_id FROM sales GROUP BY hcp_id HAVING COUNT(*)<>6;
SELECT * FROM alerts WHERE contacted NOT IN (0,1);
