with paid_orders as (

    select 
        order_id,
        customer_id,
        order_date,
        order_status,
        total_amount_paid,
        payment_finalized_date,
        customer_first_name,
        customer_last_name,
        row_number() over (order by order_id) as transaction_seq,
        row_number() over (partition by customer_id order by order_id) as customer_sales_seq
    from {{ ref('int_paid_orders') }}

)
, customer_lifetime_value as (
    select
        order_id,
        clv_bad
    from {{ ref('int_customer_lifetime_value') }}
)
, customer_orders as (

    select
        customer_id,
        first_order_date,
        most_recent_order_date,
        number_of_orders
    from {{ ref('int_customer_orders') }}

)
{% if is_incremental() %}
, max_date as (
    select max(order_date) as cutoff from {{ this }}
)
{% endif %}

-- Final CTE
, final AS (
    select
        paid_orders.order_id,
        paid_orders.customer_id as customer_id, 
        paid_orders.order_date,
        paid_orders.order_status,
        paid_orders.total_amount_paid,
        paid_orders.payment_finalized_date,
        paid_orders.customer_first_name,
        paid_orders.customer_last_name,
        paid_orders.transaction_seq,
        paid_orders.customer_sales_seq,

        case when customer_orders.first_order_date = paid_orders.order_date then 'new' else 'return' end   as nvsr,
        clv.clv_bad                                                                                             as customer_lifetime_value,
        customer_orders.first_order_date                                                                        as fdos
    from paid_orders
    left join customer_orders 
        on paid_orders.customer_id = customer_orders.customer_id
    left join customer_lifetime_value clv
        on clv.order_id = paid_orders.order_id
    order by paid_orders.order_id
)

select final.*
from final
{% if is_incremental() %}
where final.order_date >= (select cutoff from max_date)
{% endif %}