
    select 
        customers.customer_id         as customer_id
        , min(orders.order_placed_at) as first_order_date
        , max(orders.order_placed_at) as most_recent_order_date
        , count(orders.order_id)      as number_of_orders
    from {{ ref('stg_jaffle_shop___customers') }} as customers
    left join {{ ref('stg_jaffle_shop___orders') }} as orders
        on orders.customer_id = customers.customer_id 
    group by 1