select 
    orderid             as order_id
    , amount            as order_amount
    , paymentmethod     as payment_method
    , status            as order_status
    , created           as order_created_date
from {{ source("stripe","_payments") }}