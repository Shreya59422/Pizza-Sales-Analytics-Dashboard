DROP TABLE pizza_sales;

CREATE TABLE pizza_sales (
    pizza_id NUMERIC,
    order_id NUMERIC,
    pizza_name_id VARCHAR(100),
    quantity NUMERIC,
    order_date DATE,
    order_time TIME,
    unit_price NUMERIC(10,2),
    total_price NUMERIC(10,2),
    pizza_size VARCHAR(10),
    pizza_category VARCHAR(50),
    pizza_ingredients TEXT,
    pizza_name VARCHAR(100)
);