{% docs mart_customer_orders %}
Pre-aggregated orders per customer per day, designed for BI dashboards.
Grain: one row per customer × order_date × order_status.
{% enddocs %}

{% docs mart_customer_orders__customer_id %}
Foreign key to the customer who placed the order.
{% enddocs %}

{% docs mart_customer_orders__order_date %}
Date the order was placed.
{% enddocs %}

{% docs mart_customer_orders__order_status %}
Status of the order (e.g. completed, returned, placed).
{% enddocs %}

{% docs mart_customer_orders__count_orders %}
Number of orders placed by this customer on this date with this status.
{% enddocs %}

{% docs mart_customer_orders__total_revenue %}
Sum of payment amount for orders in this group.
{% enddocs %}

{% docs mart_customer_orders__customer_type %}
Indicates whether this is the customer's first order ('new') or a repeat purchase ('return').
{% enddocs %}
