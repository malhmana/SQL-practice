// segregating customers based on how much amount they have spent on our stores.

/* 
top 10% spenders - Gold
next 40% - Silver
rest 50% - Bronze
*/

WITH customer_sales_summary AS (
SELECT c.cust_id, c.customer_name, ROUND(SUM(m.sales)) as sales
FROM market_fact_full AS m
INNER JOIN cust_dimen AS c
USING(cust_id)
GROUP BY c.customer_name
) ,perc_summary AS (
SELECT *,
		PERCENT_RANK() OVER w AS perc_rank
FROM customer_sales_summary
WINDOW w AS (ORDER BY sales ASC)
) SELECT *,
		CASE
			WHEN perc_rank > 0.9 THEN 'Gold'
      WHEN perc_rank BETWEEN 0.5 AND 0.9 THEN 'Silver'
      ELSE 'Bronze'
		END AS customer_type
FROM perc_summary;
