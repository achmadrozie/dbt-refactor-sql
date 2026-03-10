{% macro compare_customer_orders() %}

{% set old_relation = ref('customer_orders') %}

{% set new_relation = ref('fact_customer_orders') %}

{{ audit_helper.compare_relations(
    a_relation = old_relation,
    b_relation = new_relation,
    exclude_columns = [],
    primary_key = "order_id"
) }}

{% endmacro %}