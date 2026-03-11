{% docs stg_jaffle_shop___customers %}
Staged customers data, one row per customer. Cleaned and renamed from the raw `_customers` source.
{% enddocs %}

{% docs stg_jaffle_shop___orders %}
Staged orders data, one row per order. Includes derived fields: `user_order_seq` and `valid_order_date`.
{% enddocs %}

{% docs customer_id %}
Unique identifier for a customer. Primary key in the customers model, foreign key elsewhere.
{% enddocs %}

{% docs customer_first_name %}
Customer's first (given) name.
{% enddocs %}

{% docs customer_last_name %}
Customer's last (family) name.
{% enddocs %}

{% docs order_id %}
Unique identifier for an order. Primary key in the orders model, foreign key elsewhere.
{% enddocs %}

{% docs order_date %}
Date the order was placed.
{% enddocs %}

{% docs order_status %}
Current status of the order. Accepted values: `completed`, `shipped`, `returned`, `placed`, `return_pending`.
{% enddocs %}