with source as (
    select
        *
    from {{ source('stripe','stripe_payments') }}
)
, transformed as (
    select
        orderid as order_id
        , status as payment_status
        , round(amount/100.0,2) payment_amount
    from source
)
select * from transformed