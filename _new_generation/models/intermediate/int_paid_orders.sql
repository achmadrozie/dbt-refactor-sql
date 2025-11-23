with orders as (
    select 
        *
    from {{ ref('stg_jaffle_shop___orders') }}
)

, customers as (
    select 
        *
    from {{ ref('stg_jaffle_shop___customers') }}
)

-- Logic CTE
, payments as (
    select
        order_id,
        payment_finalized_date,
        total_amount_paid
    from {{ ref('int_payment_orders') }}
)

-- Final CTE
, paid_orders as (

    select 
        orders.order_id,
        orders.customer_id,
        orders.order_placed_at,
        orders.order_status,
        payments.total_amount_paid,
        payments.payment_finalized_date,
        customers.customer_first_name,
        customers.customer_last_name
        
    from orders
    left join payments 
        on orders.order_id = payments.order_id
    left join customers
        on orders.customer_id = customers.customer_id 

)

select * from paid_orders