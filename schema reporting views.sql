CREATE OR REPLACE VIEW reporting.vw_sales_daily_store AS
SELECT
    s.transaction_date,
    d.year,
    d.month,
    d.month_name,
    s.store_id,
    st.store_name,
    st.region,
    COUNT(DISTINCT s.transaction_id) AS transactions,
    SUM(s.quantity) AS units_sold,
    SUM(s.sales_amount) AS gross_sales,
    SUM(s.discount_amount) AS total_discount,
    SUM(s.sales_amount - s.discount_amount) AS net_sales
FROM raw.raw_sales_store s
JOIN dim.dim_store st ON s.store_id = st.store_id
JOIN dim.dim_date d ON s.transaction_date = d.date
GROUP BY
    s.transaction_date, d.year, d.month, d.month_name,
    s.store_id, st.store_name, st.region;

CREATE OR REPLACE VIEW reporting.vw_channel_sales_daily AS
SELECT
    order_date AS sales_date,
    'Online' AS channel,
    SUM(sales_amount) AS net_sales,
    SUM(quantity) AS units_sold,
    COUNT(DISTINCT order_id) AS orders
FROM raw.raw_sales_online
GROUP BY order_date

UNION ALL

SELECT
    transaction_date AS sales_date,
    'Store' AS channel,
    SUM(sales_amount - discount_amount) AS net_sales,
    SUM(quantity) AS units_sold,
    COUNT(DISTINCT transaction_id) AS orders
FROM raw.raw_sales_store
GROUP BY transaction_date;

CREATE OR REPLACE VIEW reporting.vw_product_sales AS
SELECT
    s.transaction_date,
    p.product_id,
    p.product_name,
    p.category,
    SUM(s.quantity) AS units_sold,
    SUM(s.sales_amount - s.discount_amount) AS net_sales,
    SUM(p.cost_price * s.quantity) AS total_cost,
    SUM((s.sales_amount - s.discount_amount) - (p.cost_price * s.quantity)) AS gross_margin
FROM raw.raw_sales_store s
JOIN dim.dim_product p ON s.product_id = p.product_id
GROUP BY
    s.transaction_date,
    p.product_id, p.product_name, p.category;

CREATE OR REPLACE VIEW reporting.vw_inventory_health AS
SELECT
    i.snapshot_date,
    i.store_id,
    st.store_name,
    i.product_id,
    p.product_name,
    p.category,
    i.stock_on_hand
FROM raw.raw_inventory_snapshot i
JOIN dim.dim_store st ON i.store_id = st.store_id
JOIN dim.dim_product p ON i.product_id = p.product_id;


CREATE OR REPLACE VIEW reporting.vw_returns_summary AS
SELECT
    r.return_date,
    COUNT(DISTINCT r.order_id) AS return_orders,
    SUM(r.refund_amount) AS total_refund,
    r.return_reason
FROM raw.raw_returns r
GROUP BY
    r.return_date, r.return_reason;

CREATE OR REPLACE VIEW reporting.vw_exec_kpis_daily AS
SELECT
    transaction_date,
    SUM(net_sales) AS total_net_sales,
    SUM(units_sold) AS total_units,
    SUM(transactions) AS total_transactions,
    ROUND(SUM(net_sales) / NULLIF(SUM(transactions),0), 2) AS avg_transaction_value
FROM reporting.vw_sales_daily_store
GROUP BY transaction_date;

SELECT COUNT(*) FROM reporting.vw_sales_daily_store;
SELECT COUNT(*) FROM reporting.vw_channel_sales_daily;
SELECT COUNT(*) FROM reporting.vw_inventory_health;

SELECT COUNT(*) 
FROM reporting.vw_sales_daily_store;

SELECT 
    MIN(transaction_date), 
    MAX(transaction_date)
FROM raw.raw_sales_store;

SELECT 
    MIN(date), 
    MAX(date)
FROM dim.dim_date;


INSERT INTO dim.dim_date (date, year, month, month_name, week, day_of_week)
SELECT
    d::date AS date,
    EXTRACT(YEAR FROM d) AS year,
    EXTRACT(MONTH FROM d) AS month,
    TO_CHAR(d, 'Month') AS month_name,
    EXTRACT(WEEK FROM d) AS week,
    TO_CHAR(d, 'Day') AS day_of_week
FROM generate_series(
    '2022-01-01'::date,
    '2025-12-31'::date,
    interval '1 day'
) d;

SELECT MIN(date), MAX(date)
FROM dim.dim_date;

SELECT COUNT(*) FROM dim.dim_date;

CREATE OR REPLACE VIEW reporting.vw_sales_daily_store AS
SELECT
    s.transaction_date,
    d.year,
    d.month,
    d.month_name,
    s.store_id,
    st.store_name,
    st.region,
    COUNT(DISTINCT s.transaction_id) AS transactions,
    SUM(s.quantity) AS units_sold,
    SUM(s.sales_amount) AS gross_sales,
    SUM(s.discount_amount) AS total_discount,
    SUM(s.sales_amount - s.discount_amount) AS net_sales
FROM raw.raw_sales_store s
JOIN dim.dim_store st ON s.store_id = st.store_id
JOIN dim.dim_date d ON s.transaction_date = d.date
GROUP BY
    s.transaction_date, d.year, d.month, d.month_name,
    s.store_id, st.store_name, st.region;


	CREATE OR REPLACE VIEW reporting.vw_exec_kpis_daily AS
SELECT
    transaction_date,
    SUM(net_sales) AS total_net_sales,
    SUM(units_sold) AS total_units,
    SUM(transactions) AS total_transactions,
    ROUND(
        SUM(net_sales) / NULLIF(SUM(transactions), 0),
        2
    ) AS avg_transaction_value
FROM reporting.vw_sales_daily_store
GROUP BY transaction_date;

SELECT COUNT(*) FROM reporting.vw_sales_daily_store;

SELECT COUNT(*) FROM reporting.vw_exec_kpis_daily;

