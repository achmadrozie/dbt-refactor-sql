Skip to main content
dbt Learn
Refactoring SQL for Modularity
Search

 


 Lessons
01. Welcome 10min

Introduction
02. Part 1: Learn the refactoring process 80min

The refactoring process
Learning Objectives
Migrating legacy code
Implementing sources / translating hard-coded table references
Choosing a refactoring strategy
CTE Groupings and Cosmetic Cleanups
Centralizing Logic in Staging Tables
CTEs or intermediate models
Final models
Auditing
Knowledge check-refactoring-1
03. Setting up your environment 15min

Setting up your environment
04. Part 2: Practice refactoring 90min

Practice refactoring

 Progress 23%
AR
23%	Complete
Show Details

 Resources
 Notes
SupportSign Out
Part 1: Learn the refactoring process 80min / The refactoring process

Migrating legacy code
Note: Christine is using dbt Core version 0.19.0 in this video with a previous version of dbt Cloud. The general principles in this course remain the same, but the execution may vary across future versions of dbt.

1. Migrating Legacy Code
Note: Part 1 of this course is designed to be 'watching and learning'.  Part 2 will focus on your actually implementing and practicing these techniques. If you would like to practice alongside Christine, checkout the text walkthrough below.

1. In your dbt project, under your models folder, create a subfolder called legacy.

2. Within the legacy folder, create a file called customer_orders.sql

3. Paste the following query in the customer_orders.sql file:

select 
    orders.id as order_id,
    orders.user_id as customer_id,
    last_name as surname,
    first_name as givenname,
    first_order_date,
    order_count,
    total_lifetime_value,
    round(amount/100.0,2) as order_value_dollars,
    orders.status as order_status,
    payments.status as payment_status
from raw.jaffle_shop.orders as orders

join (
      select 
        first_name || ' ' || last_name as name, 
        * 
      from raw.jaffle_shop.customers
) customers
on orders.user_id = customers.id

join (

    select 
        b.id as customer_id,
        b.name as full_name,
        b.last_name as surname,
        b.first_name as givenname,
        min(order_date) as first_order_date,
        min(case when a.status NOT IN ('returned','return_pending') then order_date end) as first_non_returned_order_date,
        max(case when a.status NOT IN ('returned','return_pending') then order_date end) as most_recent_non_returned_order_date,
        COALESCE(max(user_order_seq),0) as order_count,
        COALESCE(count(case when a.status != 'returned' then 1 end),0) as non_returned_order_count,
        sum(case when a.status NOT IN ('returned','return_pending') then ROUND(c.amount/100.0,2) else 0 end) as total_lifetime_value,
        sum(case when a.status NOT IN ('returned','return_pending') then ROUND(c.amount/100.0,2) else 0 end)/NULLIF(count(case when a.status NOT IN ('returned','return_pending') then 1 end),0) as avg_non_returned_order_value,
        array_agg(distinct a.id) as order_ids

    from (
      select 
        row_number() over (partition by user_id order by order_date, id) as user_order_seq,
        *
      from raw.jaffle_shop.orders
    ) a

    join ( 
      select 
        first_name || ' ' || last_name as name, 
        * 
      from raw.jaffle_shop.customers
    ) b
    on a.user_id = b.id

    left outer join raw.stripe.payment c
    on a.id = c.orderid

    where a.status NOT IN ('pending') and c.status != 'fail'

    group by b.id, b.name, b.last_name, b.first_name

) customer_order_history
on orders.user_id = customer_order_history.customer_id

left outer join raw.stripe.payment payments
on orders.id = payments.orderid

where payments.status != 'fail'
4. Conduct a dbt run -m customer_orders to ensure your model builds successfully in the warehouse. You should see this model under {your development schema}.customer_orders (i.e, dbt_cberger.customer_orders)



