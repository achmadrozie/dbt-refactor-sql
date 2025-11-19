select
    *
from {{ source('stripe','stripe_payments') }}