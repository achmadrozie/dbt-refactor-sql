with paid_orders as (
    select *
    from {{ ref('int_paid_orders') }}
)
    
, customer_lifetime_value as (
    select
        p.order_id,
        sum(t2.total_amount_paid) as clv_bad
    from paid_orders p
    left join paid_orders t2 
        on p.customer_id = t2.customer_id 
        and p.order_id >= t2.order_id
    group by 1
    order by p.order_id
)

select 
    * 
from customer_lifetime_value
