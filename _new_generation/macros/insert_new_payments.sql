{% macro insert_new_payments() %}

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
{% do log("✅ Inserted 5 new payments!", info=True) %}

{% endmacro %}