with payments as (
    select
        *
    from {{ ref('stg_stripe___payments') }}
)
, aggregated as (
    select sum(order_amount) as total_revenue
    from payments where order_status = 'success'

)

select * from aggregated

