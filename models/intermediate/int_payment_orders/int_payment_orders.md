{% docs int_payment_orders %}
Aggregated payment totals per order. Excludes failed payments. One row per order.
{% enddocs %}

{% docs payment_finalized_date %}
Date the payment was finalized (max of order_created_date across all payments for this order).
{% enddocs %}

{% docs total_amount_paid %}
Total amount paid for this order in dollars (already divided by 100 from raw cents).
{% enddocs %}