{% macro insert_new_orders() %}

{% set insert_orders %}
    INSERT INTO dbt_refactor.public._orders (id, user_id, order_date, status)
    VALUES
    (100, 100, '2025-02-15', 'shipped'),
    (101, 84, '2025-02-15', 'shipped'),
    (102, 42, '2025-02-15', 'shipped'),
    (103, 101, '2025-02-15', 'shipped'),
    (104, 66, '2025-02-15', 'shipped');
{% endset %}

{% do run_query(insert_orders) %}
{% do log("✅ Inserted 5 new orders!", info=True) %}

{% endmacro %}
