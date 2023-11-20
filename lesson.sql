-- Active: 1700416325724@@127.0.0.1@5432@db_hw

select *,
       count(*) over(partition by "date") as cnt
from invoice
order by "date"

# скользящая сумма

with "money" as (
    select "date",
           shop_ref,
           price_per_one * amount as "invoice_money"
    from invoice
)
select "date",
       shop_ref,
       invoice_money,
       sum(invoice_money) over(partition by shop_ref order by "date") as "run_sum"
from "money"