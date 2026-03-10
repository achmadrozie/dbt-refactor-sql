{% macro insert_new_customers() %}

{% set insert_customers %}
    INSERT INTO dbt_refactor.public._customers (id, first_name, last_name)
    VALUES
    (101, 'Michelle', 'B.'),
    (102, 'Faith', 'L.');
{% endset %}

{% do run_query(insert_customers) %}
{% do log("✅ Inserted 2 new customers!", info=True) %}

{% endmacro %}
