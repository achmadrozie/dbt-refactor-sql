/***
    1. ENVIRONMENT SETUP
        - Enable dataset on seeds
        - Enable legacy models
        - Enable Macros (e.g. audit_helper)
        - Push to Remote Repo
        - Lower Case

    2. SOURCE ENABLEMENT
        - Create Sources (yml)
        - Update Sources (in marts)
        - Tidy Up (indentation, on, etc.)
        - Add source freshness tests
        - Add base schema tests (unique, not_null)

    3. LOGIC CTE ENABLEMENT -> PUSH TO SOURCE
        - Intermediary-ing UP (rework join -> CTE)
        
        - Simplifying column name modification on CTE logic and move to the source table
            - payments
            - orders
            - customers
        - Ensure column names match legacy for comparison
    
    4. INTERMEDIATE LAYER
       - int_payment_orders: Payment aggregations
       - int_paid_orders: Orders + Payments + Customers
       - int_customer_orders: Customer aggregation stats
       - int_customer_lifetime_value: CLV self-join calculation
    
    5. MART LAYER
       - Business logic (nvsr, fdos)
       - Final transformations
       - Add comprehensive documentation (on md files)

    -- result test (QA)
    6. TESTING THROUGHOUT
       - Schema tests at each layer
       - audit_helper comparisons at staging & intermediate
       - Custom data tests for business rules
       - Performance benchmarks

    -- bonus (post work)

    7. CUTOVER & CLEANUP
       - Run legacy + new models in parallel (monitoring period)
       - Update downstream dependencies (BI, reports)
       - Monitor for discrepancies
       - Deprecate legacy models
       - Archive/remove old code
***/


-- Logic CTE
