CREATE TABLE raw.raw_sales_store (
    transaction_id BIGINT,
    transaction_date DATE,
    store_id INT,
    product_id INT,
    quantity INT,
    sales_amount NUMERIC(10,2),
    discount_amount NUMERIC(10,2)
);

CREATE TABLE raw.raw_sales_online (
    order_id BIGINT,
    order_date DATE,
    customer_id INT,
    product_id INT,
    quantity INT,
    sales_amount NUMERIC(10,2),
    channel TEXT
);

CREATE TABLE raw.raw_inventory_snapshot (
    snapshot_date DATE,
    store_id INT,
    product_id INT,
    stock_on_hand INT
);

CREATE TABLE raw.raw_returns (
    order_id BIGINT,
    return_date DATE,
    refund_amount NUMERIC(10,2),
    return_reason TEXT
);

CREATE TABLE raw.raw_promotions (
    promo_id INT,
    product_id INT,
    start_date DATE,
    end_date DATE,
    discount_pct NUMERIC(5,2)
);

CREATE TABLE dim.dim_store (
    store_id INT PRIMARY KEY,
    store_name TEXT,
    region TEXT,
    city TEXT,
    store_type TEXT
);

CREATE TABLE dim.dim_product (
    product_id INT PRIMARY KEY,
    product_name TEXT,
    category TEXT,
    sub_category TEXT,
    cost_price NUMERIC(10,2)
);

CREATE TABLE dim.dim_customer (
    customer_id INT PRIMARY KEY,
    gender TEXT,
    age INT,
    city TEXT
);

CREATE TABLE dim.dim_date (
    date DATE PRIMARY KEY,
    year INT,
    month INT,
    month_name TEXT,
    week INT,
    day_of_week TEXT
);

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema IN ('raw','dim');

SELECT COUNT(*) FROM raw.raw_sales_store;
SELECT COUNT(*) FROM raw.raw_sales_online;
SELECT COUNT(*) FROM raw.raw_inventory_snapshot;
SELECT COUNT(*) FROM raw.raw_returns;
