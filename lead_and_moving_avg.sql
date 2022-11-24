CREATE VIEW ORDER_SUMMARY AS (
SELECT DISTINCT order_date, customer_name
FROM market_fact_full
INNER JOIN cust_dimen
USING(cust_id)
INNER JOIN orders_dimen
USING(ord_id)

) ;

WITH dates_summary AS(
SELECT *, DATEDIFF(LEAD(order_date,1) OVER w, order_date) AS Days_between_order
FROM ORDER_SUMMARY
WINDOW w AS (PARTITION BY customer_name ORDER BY order_date)
ORDER BY customer_name, order_date
) SELECT *, AVG(Days_between_order) OVER w1 AS 'average days'
FROM dates_summary
WINDOW w1 AS (PARTITION BY customer_name ORDER BY customer_name ROWS UNBOUNDED PRECEDING);
