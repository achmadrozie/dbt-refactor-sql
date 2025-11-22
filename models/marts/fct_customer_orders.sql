-- Import CTEs
with

orders as (
    select * from {{ ref('int_orders')}}
)

, customers as (
    select
        *
    from {{ ref('_stg_jaffle_shop__customers') }}
)

-- Customer-level aggregations (one row per customer)
, customer_metrics as (
    select
        customers.customer_id,
        customers.surname,
        customers.givenname,
        customers.full_name,

        -- Customer level aggregations
        min(orders.order_date) as first_order_date,
        min(orders.valid_order_date) as first_non_returned_order_date,
        max(orders.valid_order_date) as most_recent_non_returned_order_date,
        count(*) as order_count,
        sum(nvl2(orders.valid_order_date, 1, 0)) as non_returned_order_count,
        sum(nvl2(orders.valid_order_date, orders.order_value_dollars, 0)) as total_lifetime_value

    from orders
    join customers
        on orders.customer_id = customers.customer_id
    group by 1, 2, 3, 4
)

, customer_metrics_with_avg as (
    select
        *,
        total_lifetime_value / nullif(non_returned_order_count, 0) as avg_non_returned_order_value
    from customer_metrics
)

-- Final CTE: Join order-level data with customer-level metrics
, final as (
    select
        orders.order_id,
        orders.customer_id,
        cm.surname,
        cm.givenname,

        cm.first_order_date,
        cm.order_count,
        cm.total_lifetime_value,
        cm.avg_non_returned_order_value,

        orders.order_value_dollars,
        orders.order_status,
        orders.payment_status

    from orders
    join customer_metrics_with_avg as cm
        on orders.customer_id = cm.customer_id
)

select * from final




