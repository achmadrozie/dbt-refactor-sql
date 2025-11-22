select 
    * 
from {{ source("jaffle_shop","_orders") }}