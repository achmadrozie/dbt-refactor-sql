{% docs count_completed_order %}

Total number of orders with status `completed`.

**Grain:** One row per order (`order_id`)

**Source:** `fact_customer_orders`

**Measure type:** Additive — safe to sum across any dimension (date, customer)

**Example use cases:**
- Completed order volume trend over time
- Completion rate denominator per customer segment
- Completed orders by date for revenue reconciliation

{% enddocs %}