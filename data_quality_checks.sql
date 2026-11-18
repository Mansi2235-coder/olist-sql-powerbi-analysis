-- Data quality checks for the Olist SQLite database (OLIST Project.db)
-- Run each query one at a time in DB Browser for SQLite (Execute SQL tab).

-- 1. Row counts
SELECT 'orders' AS tbl, COUNT(*) AS n FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL SELECT 'customers', COUNT(*) FROM customers;

-- 2. Duplicate orders
SELECT order_id, COUNT(*) FROM orders GROUP BY order_id HAVING COUNT(*) > 1;

-- 3. Delivered orders with no delivery date
SELECT COUNT(*) FROM orders
WHERE order_status = 'delivered' AND order_delivered_customer_date IS NULL;

-- 4. Order items with no matching order
SELECT COUNT(*) FROM order_items i
LEFT JOIN orders o ON i.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 5. Orders with no matching customer
SELECT COUNT(*) FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 6. Delivered before purchased
SELECT COUNT(*) FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp;

-- 7. Review scores outside 1 to 5
SELECT COUNT(*) FROM order_reviews WHERE review_score NOT BETWEEN 1 AND 5;
