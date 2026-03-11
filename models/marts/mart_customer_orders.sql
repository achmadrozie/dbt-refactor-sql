select
    customer_id
    , order_date
    , order_status
    , count(order_id)           as count_orders
    , sum(total_amount_paid)    as total_revenue
    , max(nvsr)                 as customer_type  -- 'new' or 'return'
from {{ ref('fact_customer_orders') }}
group by 1, 2, 3
