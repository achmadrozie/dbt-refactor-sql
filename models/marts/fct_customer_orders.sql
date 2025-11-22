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
--
, customer_orders as (
    select
        customers.customer_id
        , customers.surname
        , customers.givenname
        , customers.full_name

        -- Customer level aggregations
        , min(orders.order_date) over(
            partition by customers.customer_id
            ) as customer_first_order_date
        , min(orders.valid_order_date) over(
            partition by customers.customer_id
            ) as customer_first_non_returned_order_date

        , max(orders.valid_order_date) over(
            partition by customers.customer_id
            ) as customer_most_recent_non_returned_order_date

        , count(*) over (
            partition by orders.customer_id
            ) as customer_order_count

        , sum(nvl2(orders.valid_order_date, 1, 0)) over(
            partition by orders.customer_id
            ) as customer_non_returned_order_count
        
        , sum(nvl2(orders.valid_order_date, orders.order_value_dollars, 0)) over(
            partition by customers.customer_id
            ) as customer_total_lifetime_value

    from orders
    join customers
        on orders.customer_id = customers.customer_id
)

, add_avg_order_values as (
    select
        *
        , customer_total_lifetime_value / customer_non_returned_order_count as customer_avg_non_returned_order_value
    from customer_orders
)

-- Final CTEs
, final as (
    select 
        orders.order_id,
        orders.customer_id,
        customers.surname,
        customers.givenname,

        customer_first_order_date as first_order_date,
        customer_order_count as order_count,
        customer_total_lifetime_value as total_lifetime_value,

        orders.order_value_dollars,
        orders.order_status,
        orders.payment_status
    from orders
    join customers
        on orders.customer_id = customers.customer_id

    join add_avg_order_values as customer_orders
        on orders.customer_id = customer_orders.customer_id
)
select * from final




