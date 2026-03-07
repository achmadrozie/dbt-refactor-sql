# dbt Refactor SQL — Learning Portfolio

> A hands-on dbt learning project demonstrating how to refactor legacy monolithic SQL into a modern, modular, and testable data pipeline.

---

## 📌 Project Overview

This project is a **portfolio piece** showcasing the process of refactoring a complex legacy SQL query into a well-structured dbt project. It covers the full lifecycle of a modern analytics engineering workflow — from raw source data to business-ready mart models.

The dataset is based on the classic **Jaffle Shop** demo (a fictional e-commerce store) with payment data from **Stripe**, commonly used in dbt learning exercises.

---

## 🎯 Learning Objectives

- Understand dbt project structure and configuration
- Apply the **medallion architecture** (staging → intermediate → marts)
- Refactor nested SQL subqueries into modular, reusable CTEs
- Implement **incremental models** for performance optimization
- Write **schema tests** and use **audit_helper** for data validation
- Use **sources**, **seeds**, **macros**, and **packages**
- Follow analytics engineering best practices

---

## 🏗️ Architecture

```
Raw Sources (Snowflake)
        │
        ▼
┌─────────────────┐
│  Staging Layer  │  ← Clean & rename columns, no business logic
│  (Views)        │
└────────┬────────┘
         │
         ▼
┌─────────────────────┐
│ Intermediate Layer  │  ← Business logic, aggregations, joins
│ (Tables)            │
└──────────┬──────────┘
           │
           ▼
┌─────────────────┐
│   Mart Layer    │  ← Final business-ready models, incremental
│   (Tables)      │
└─────────────────┘
```

---

## 📁 Project Structure

```
dbt-refactor-sql/
├── _new_generation/              # ✨ New modular dbt models (active development)
│   ├── models/
│   │   ├── staging/
│   │   │   ├── jaffle_shop/      # Customer & order staging models
│   │   │   └── stripe/           # Payment staging models
│   │   ├── intermediate/         # Business logic layer
│   │   └── marts/                # Final analytics models
│   ├── macros/                   # Custom Jinja macros
│   └── seeds/                    # CSV seed files for test data
│
├── models/                       # 🗂️ Legacy models (for comparison/reference)
│   ├── legacy/                   # Original monolithic SQL
│   ├── intermediate/
│   └── marts/
│
├── seeds/                        # Raw CSV data files
├── analyses/                     # Ad-hoc SQL queries
├── tests/                        # Custom data tests
├── dbt_project.yml               # Project configuration
└── packages.yml                  # dbt package dependencies
```

---

## 🔄 The Refactoring Journey

### Before: Legacy Monolithic SQL

The original `customer_orders.sql` was a single, deeply nested query with:
- Multiple subqueries inside `JOIN` clauses
- Hardcoded table references (`public.jaffle_shop_orders`)
- Mixed concerns (cleaning, joining, aggregating) in one place
- Difficult to test, maintain, or reuse

### After: Modular dbt Pipeline

The refactored pipeline breaks the logic into focused, testable models:

| Model | Layer | Purpose |
|-------|-------|---------|
| `stg_jaffle_shop___customers` | Staging | Clean & rename customer columns |
| `stg_jaffle_shop___orders` | Staging | Clean & rename order columns |
| `stg_stripe___payments` | Staging | Clean & rename payment columns |
| `int_payment_orders` | Intermediate | Aggregate payments by order, convert cents → dollars |
| `int_paid_orders` | Intermediate | Join orders + payments + customers |
| `int_customer_orders` | Intermediate | Customer-level order statistics |
| `int_customer_lifetime_value` | Intermediate | Cumulative CLV via self-join |
| `fact_customer_orders` | Mart | Final model with business metrics (nvsr, fdos, clv) |

---

## 📊 Data Model

### Sources
- **jaffle_shop** (`_customers`, `_orders`) — E-commerce platform data
- **stripe** (`_payments`) — Payment processor data

### Key Business Metrics in `fact_customer_orders`

| Metric | Column | Description |
|--------|--------|-------------|
| New vs. Return | `nvsr` | `'new'` if first order, `'return'` otherwise |
| First Date of Sale | `fdos` | Date of customer's first order |
| Customer Lifetime Value | `customer_lifetime_value` | Cumulative spend up to each order |
| Transaction Sequence | `transaction_seq` | Global order sequence number |
| Customer Sales Sequence | `customer_sales_seq` | Per-customer order sequence |

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| **dbt Core** | Data transformation framework |
| **Snowflake** | Cloud data warehouse |
| **audit_helper** (dbt-labs) | Compare legacy vs. new model outputs |
| **dbt_meta_testing** | Enforce test coverage requirements |

---

## 📦 Packages

```yaml
# packages.yml
packages:
  - package: dbt-labs/audit_helper
    version: 0.12.2

  - package: tnightengale/dbt_meta_testing
    version: 0.3.6
```

- **audit_helper**: Used to validate that the refactored models produce identical results to the legacy query
- **dbt_meta_testing**: Enforces that all models have minimum test coverage (`unique` + `not_null`)

---

## 🧪 Testing Strategy

This project implements a multi-layer testing approach:

### 1. Schema Tests (YAML)
```yaml
columns:
  - name: order_id
    tests:
      - unique
      - not_null
```

### 2. Relationship Tests
```yaml
- name: customer_id
  tests:
    - relationships:
        to: ref('stg_jaffle_shop___customers')
        field: customer_id
```

### 3. Accepted Values Tests
```yaml
- name: order_status
  tests:
    - accepted_values:
        values: ['placed', 'shipped', 'completed', 'return_pending', 'returned']
```

### 4. Audit Helper Comparison
```sql
-- macros/compare_relations.sql
{{ audit_helper.compare_relations(
    a_relation = ref('customer_orders'),   -- legacy
    b_relation = ref('fact_customer_orders'), -- new
    primary_key = "order_id"
) }}
```

---

## ⚡ Incremental Model

The `fact_customer_orders` mart uses an **incremental merge strategy**:

```sql
{{
    config(
        materialized='incremental',
        unique_key = 'order_id',
        incremental_strategy = 'merge',
        on_schema_change = 'fail'
    )
}}

{% if is_incremental() %}
    where order_placed_at >= (select max(order_placed_at) from {{ this }})
{% endif %}
```

This ensures only new/updated records are processed on each run, improving performance at scale.

---

## 🚀 Getting Started

### Prerequisites
- dbt Core installed (`pip install dbt-snowflake`)
- Snowflake account with appropriate credentials
- dbt profile configured (`~/.dbt/profiles.yml`)

### Setup

```bash
# Clone the repository
git clone https://github.com/achmadrozie/dbt-refactor-sql.git
cd dbt-refactor-sql

# Install dbt packages
dbt deps

# Load seed data
dbt seed

# Run all models
dbt run

# Run tests
dbt test

# Generate and serve documentation
dbt docs generate
dbt docs serve
```

### Run Specific Layers

```bash
# Run only staging models
dbt run --select staging

# Run only intermediate models
dbt run --select intermediate

# Run only mart models
dbt run --select marts

# Run with dependencies
dbt run --select +fact_customer_orders
```

---

## 📋 Refactoring Methodology

This project follows a structured 7-step refactoring process:

1. **Environment Setup** — Seeds, legacy models, macros, packages
2. **Source Enablement** — Define sources in YAML, add freshness tests
3. **Logic CTE Enablement** — Break nested subqueries into CTEs, move transformations to staging
4. **Intermediate Layer** — Create reusable intermediate models for each business domain
5. **Mart Layer** — Final business logic with incremental loading
6. **Testing Throughout** — Schema tests, audit_helper comparisons, custom data tests
7. **Cutover & Cleanup** — Parallel runs, monitoring, deprecate legacy models

---

## 📚 Key dbt Concepts Demonstrated

| Concept | Where Used |
|---------|-----------|
| `{{ ref() }}` | All models — model dependencies |
| `{{ source() }}` | Staging models — raw table references |
| `{{ config() }}` | Mart models — materialization settings |
| `{{ is_incremental() }}` | `fact_customer_orders` — incremental logic |
| Sources YAML | `_sources.yml` — source definitions |
| Schema YAML | `schema.yml` — tests & documentation |
| Seeds | `_new_generation/seeds/` — test data |
| Macros | `compare_relations.sql` — reusable logic |
| Packages | `audit_helper`, `dbt_meta_testing` |

---

## 👤 Author

**Achmad Rozie**  
Learning dbt through hands-on refactoring exercises.

- GitHub: [@achmadrozie](https://github.com/achmadrozie)

---

## 📄 License

This project is for educational purposes, based on the [dbt Jaffle Shop](https://github.com/dbt-labs/jaffle_shop) demo dataset.
