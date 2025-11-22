select 
    * 
from {{ source("stripe","_payments") }}