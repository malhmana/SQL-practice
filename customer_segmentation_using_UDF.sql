-- Similarly when segmenting customers with how much money they have spent on our service. We can also do that using a by declaring a function.

/* 
top 10% spenders - Gold
next 40% - Silver
rest 50% - Bronze
*/

DELIMITER $$

CREATE FUNCTION customer_segment(sales_perc_rank int)
RETURNS VARCHAR(30) DETERMINISTIC

BEGIN

DECLARE cust_type VARCHAR(30);
IF sales_perc_rank >= 0.9 THEN
	SET cust_type = 'Gold';
ELSEIF sales_perc_rank BETWEEN 0.5 AND 0.9 THEN
	SET cust_type = 'Silver';
ELSE
	SET cust_type = 'Bronze';
END IF;

RETURN cust_type;

END;
$$
DELIMITER ;

use market_star_schema;

WITH cust_sales_summary AS (
SELECT c.cust_id, c.customer_name, SUM(m.sales) AS sum_sales
FROM market_fact_full AS m
INNER JOIN
cust_dimen AS c
USING(cust_id)
GROUP BY c.cust_id
)SELECT *,
		customer_segment(PERCENT_RANK() OVER w) AS customer_segment
FROM cust_sales_summary
WINDOW w AS (ORDER BY sum_sales);
