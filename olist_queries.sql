Olist E-Commerce Analysis: SQL queries (SQLite)

 1. Top 15 product categories by revenue (English names)
SELECT t.product_category_name_english AS category, SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN category_translation t ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY revenue DESC
LIMIT 15;

 2. Monthly revenue (delivered orders only)
SELECT strftime('%Y-%m', o.order_purchase_timestamp) AS month,
       SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;

3. Average delivery time and share of late deliveries
SELECT
  ROUND(AVG(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)), 1) AS avg_delivery_days,
  ROUND(100.0 * SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) / COUNT(*), 1) AS late_percent
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date <> '';

4. Review score: late vs on-time deliveries
SELECT
  CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
       THEN 'late' ELSE 'on time' END AS delivery_status,
  COUNT(*) AS orders,
  ROUND(AVG(r.review_score), 2) AS avg_review
FROM orders o
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date <> ''
GROUP BY delivery_status;

5. Share of repeat customers
SELECT
  COUNT(*) AS customers,
  SUM(CASE WHEN n_orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
  ROUND(100.0 * SUM(CASE WHEN n_orders > 1 THEN 1 ELSE 0 END) / COUNT(*), 1) AS repeat_percent
FROM (
  SELECT c.customer_unique_id, COUNT(o.order_id) AS n_orders
  FROM orders o
  JOIN customers c ON o.customer_id = c.customer_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id
);

6. Revenue and orders by state (delivered orders only)
SELECT c.customer_state,
       COUNT(DISTINCT o.order_id) AS orders,
       ROUND(SUM(oi.price), 0) AS revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY revenue DESC;

7. Total revenue (delivered orders)
SELECT ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';