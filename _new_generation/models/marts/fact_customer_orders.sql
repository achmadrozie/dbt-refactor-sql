/***
    1. ENVIRONMENT SETUP
        - Enable dataset on seeds
        - Enable legacy models
        - Enable Macros (e.g. audit_helper)
        - Push to Remote Repo
        - Lower Case

    2. SOURCE ENABLEMENT
        - Create Sources (yml)
        - Update Sources (in marts)
        - Tidy Up (indentation, on, etc.)
        - Add source freshness tests
        - Add base schema tests (unique, not_null)

    3. LOGIC CTE ENABLEMENT -> PUSH TO SOURCE
        - Intermediary-ing UP (rework join -> CTE)
        
        - Simplifying column name modification on CTE logic and move to the source table
            - payments
            - orders
            - customers
        - Ensure column names match legacy for comparison
    
    4. INTERMEDIATE LAYER
       - int_payment_orders: Payment aggregations
       - int_paid_orders: Orders + Payments + Customers
       - int_customer_orders: Customer aggregation stats
       - int_customer_lifetime_value: CLV self-join calculation
    
    5. MART LAYER
       - Business logic (nvsr, fdos)
       - Final transformations
       - Add comprehensive documentation (on md files)

    -- result test (QA)
    6. TESTING THROUGHOUT
       - Schema tests at each layer
       - audit_helper comparisons at staging & intermediate
       - Custom data tests for business rules
       - Performance benchmarks

    -- bonus (post work)

    7. CUTOVER & CLEANUP
       - Run legacy + new models in parallel (monitoring period)
       - Update downstream dependencies (BI, reports)
       - Monitor for discrepancies
       - Deprecate legacy models
       - Archive/remove old code
***/


-- Logic CTE

{{
    config(
        materialized='incremental',
        unique_key = 'order_id',
        incremental_strategy = 'merge',
        on_schema_change = 'fail'
    )
}}

with paid_orders as (

    select 
        order_id,
        customer_id,
        order_placed_at,
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

-- Final CTE
, final AS (
    select
        paid_orders.order_id,
        paid_orders.customer_id as customer_id, 
        paid_orders.order_placed_at,
        paid_orders.order_status,
        paid_orders.total_amount_paid,
        paid_orders.payment_finalized_date,
        paid_orders.customer_first_name,
        paid_orders.customer_last_name,
        paid_orders.transaction_seq,
        paid_orders.customer_sales_seq,

        case when customer_orders.first_order_date = paid_orders.order_placed_at then 'new' else 'return' end   as nvsr,
        clv.clv_bad                                                                                             as customer_lifetime_value,
        customer_orders.first_order_date                                                                        as fdos
    from paid_orders
    left join customer_orders 
        on paid_orders.customer_id = customer_orders.customer_id
    left join customer_lifetime_value clv
        on clv.order_id = paid_orders.order_id
    order by order_id
)

select * 
from final

{% if is_incremental() %}
    where order_placed_at >= (select max(order_placed_at) from {{ this }})
{% endif %}