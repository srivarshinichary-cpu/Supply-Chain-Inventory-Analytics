-- Starter SQL: adapt date functions to your database (PostgreSQL syntax)
-- 1) Products below reorder level
SELECT p.product_id, p.product_name, i.available_stock, p.reorder_level
FROM products p JOIN inventory_snapshot i USING (product_id)
WHERE i.available_stock < p.reorder_level
ORDER BY (p.reorder_level - i.available_stock) DESC;

-- 2) Monthly sales
SELECT DATE_TRUNC('month', order_date)::date AS sales_month,
       SUM(quantity_sold) AS units_sold,
       ROUND(SUM(sales_revenue)::numeric, 2) AS revenue
FROM sales_orders
GROUP BY 1 ORDER BY 1;

-- 3) Supplier delivery performance
SELECT s.supplier_name,
       COUNT(*) AS purchase_orders,
       ROUND(AVG(po.delivery_delay_days)::numeric, 2) AS avg_delay_days,
       ROUND(100.0 * AVG(CASE WHEN po.delivery_delay_days = 0 THEN 1.0 ELSE 0.0 END), 2) AS on_time_pct
FROM purchase_orders po JOIN suppliers s USING (supplier_id)
GROUP BY s.supplier_name
ORDER BY avg_delay_days DESC;
