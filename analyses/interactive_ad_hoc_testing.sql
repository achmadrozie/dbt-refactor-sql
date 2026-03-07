select 
    customer_id 
from {{ ref('fact_customer_orders') }} 
group by customer_id 
having count(*) > 1
