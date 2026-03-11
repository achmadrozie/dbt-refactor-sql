{% docs stg_stripe___payments %}
Staged payment data, one row per payment. Amount is pre-divided by 100 (converted from cents to dollars).
{% enddocs %}

{% docs payment_id %}
Unique identifier for a payment. Primary key in the payments model.
{% enddocs %}

{% docs order_id__payments %}
Foreign key to the order this payment belongs to. References `stg_jaffle_shop___orders.order_id`.
{% enddocs %}