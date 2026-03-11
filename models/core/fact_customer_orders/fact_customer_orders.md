{% docs fact_customer_orders %}
Final fact table for customer orders. One row per order. Combines orders, payments, customer stats, and lifetime value. Built incrementally using merge strategy on `order_id`.
{% enddocs %}

{% docs transaction_seq %}
Global transaction sequence number ordered by order_id across all customers.
{% enddocs %}

{% docs customer_sales_seq %}
Per-customer order sequence number. 1 = first order, 2 = second order, etc.
{% enddocs %}

{% docs nvsr %}
New vs. Return flag. 'new' if this order's date equals the customer's first order date, otherwise 'return'.
{% enddocs %}

{% docs customer_lifetime_value %}
Cumulative spend by the customer up to and including this order (CLV calculation).
{% enddocs %}

{% docs fdos %}
First date of sale — the date of the customer's first ever order.
{% enddocs %}
