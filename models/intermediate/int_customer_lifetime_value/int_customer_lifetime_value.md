{% docs int_customer_lifetime_value %}
Cumulative lifetime value per order, calculated as a running total of all payments made by the same customer up to and including this order.
{% enddocs %}

{% docs clv_bad %}
Cumulative revenue from this customer up to and including this order. Called 'bad' because it uses a simplistic self-join approach rather than a proper window function.
{% enddocs %}