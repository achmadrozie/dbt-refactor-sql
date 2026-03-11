{% docs completed_order_rate %}

Proportion of orders that reached `completed` status out of all orders placed.

**Formula:** `count_completed_order / count_order`

**Range:** 0.0 – 1.0

**Metric type:** Derived — do NOT sum across dimensions; always compute from the two component metrics

**Example use cases:**
- Track completion rate trend over time (daily / weekly)
- Compare completion rate across customer segments
- Identify periods or cohorts with unusually low completion rates

{% enddocs %}