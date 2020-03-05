WITH 
orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
)
, payment as (
    select * from {{ ref('stg_stripe__payments') }}
)

, order_payments as (
    select
          order_id
        , SUM(amount) AS amount
    from payment
    group by order_id
)

, final as (
    select
          orders.order_id
        , orders.customer_id
        , orders.order_date
        , orders.status
        , IFNULL(order_payments.amount, 0) AS amount
    from orders
    LEFT JOIN order_payments
           ON orders.order_id = order_payments.order_id
)

SELECT * FROM final