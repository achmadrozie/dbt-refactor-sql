select 
    * 
from {{ source("jaffle_shop","_customers") }}