{% docs count_order %}

Total number of orders placed, regardless of status.

**Grain:** One row per order (`order_id`)

**Source:** `fact_customer_orders`

**Measure type:** Additive — safe to sum across any dimension (date, customer, status)

**Example use cases:**
- Daily / weekly / monthly order volume trend
- Orders by customer segment
- Orders by order status breakdown

{% enddocs %}
