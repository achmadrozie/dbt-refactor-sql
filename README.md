# dbt Refactor SQL

> Refactoring a legacy monolithic SQL query into a modern, modular dbt pipeline.

<img width="3448" height="640" alt="image" src="https://github.com/user-attachments/assets/167c610e-b40e-487c-a82a-f34500e36410" />


---

## What This Project Does

Takes a deeply nested legacy SQL query and breaks it into a clean, testable dbt pipeline using the **Jaffle Shop** dataset (fictional e-commerce + Stripe payments).

---

## Architecture

| Layer | Models | Purpose |
|-------|--------|---------|
| Staging | `stg_jaffle_shop__*`, `stg_stripe__*` | Clean & rename columns |
| Intermediate | `int_payment_orders`, `int_paid_orders`, `int_customer_lifetime_value`, `int_customer_orders` | Business logic & joins |
| Core | `fact_customer_orders` | Incremental fact table |
| Marts | `mart_customer_orders` | Pre-aggregated for BI |
| Semantic | `semantic_fact_customer_orders` | MetricFlow measures |
| Metrics | `count_order`, `count_completed_order`, `completed_order_rate` | dbt Semantic Layer |

---

## Key Concepts Demonstrated

- Modular CTE refactoring
- Incremental models (`merge` strategy)
- Sources, seeds, macros, packages
- Schema tests + `audit_helper` for legacy comparison
- dbt Semantic Layer + MetricFlow metrics

---

## Tech Stack

- **dbt Core** + **DuckDB**
- `dbt-labs/audit_helper` — validate refactored output matches legacy
- `tnightengale/dbt_meta_testing` — enforce test coverage

---

## Getting Started

```bash
git clone https://github.com/achmadrozie/dbt-refactor-sql.git
cd dbt-refactor-sql
dbt deps && dbt seed && dbt run && dbt test
```

---

**Achmad Rozie** — [@achmadrozie](https://github.com/achmadrozie)
