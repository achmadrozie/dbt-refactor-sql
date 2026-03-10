{% macro insert_all_exercise_data() %}

{{ log("🚀 Inserting exercise data into source tables...", info=True) }}

{# Insert Customers #}
{% set insert_customers %}
    INSERT INTO dbt_refactor.public._customers (id, first_name, last_name)
    VALUES
    (101, 'Michelle', 'B.'),
    (102, 'Faith', 'L.');
{% endset %}
{% do run_query(insert_customers) %}
{{ log("  ✅ Inserted 2 new customers", info=True) }}

{# Insert Orders #}
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
{{ log("  ✅ Inserted 5 new orders", info=True) }}

{# Insert Payments #}
{% set insert_payments %}
    INSERT INTO dbt_refactor.public._payments (id, orderid, paymentmethod, status, amount, created)
    VALUES
    (121, 100, 'bank_transfer', 'success', 1000, '2025-02-14'),
    (122, 101, 'credit_card', 'fail', 400, '2025-02-14'),
    (123, 102, 'credit_card', 'success', 1900, '2025-02-14'),
    (124, 103, 'credit_card', 'success', 1000, '2025-02-15'),
    (125, 104, 'coupon', 'success', 100, '2025-02-15');
{% endset %}
{% do run_query(insert_payments) %}
{{ log("  ✅ Inserted 5 new payments", info=True) }}

{{ log("🎉 All exercise data inserted successfully!", info=True) }}

{% endmacro %}