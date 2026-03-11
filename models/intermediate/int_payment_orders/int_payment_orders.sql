with base_payments as (
    select
        *
    from {{ ref('stg_stripe___payments') }}
)
-- Logic CTE
, aggregated as (
    select 
        order_id
        , max(order_created_date) as payment_finalized_date
        , sum(payment_amount) as total_amount_paid
    from base_payments
        where payment_status <> 'fail'
    group by 1
)

select * from aggregated
