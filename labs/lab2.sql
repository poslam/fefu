-- Active: 1698192534173@@127.0.0.1@8880@db

# 1

select * 
from sales
where shop_ref = '21393d64-1e5d-4670-a184-35c538e4eb79' 
    and nomenclature_ref = '4ef11378-7012-48a9-9228-c6898aa1ea64'
    and amount > 1000
order by amount;

# 2

with temp_table (nomenclature_ref) as
(
    select nomenclature_ref
    from writeoffs
    where amount * price_per_one = 
    (
        select max(amount * price_per_one)
        from writeoffs
        where to_char("date", 'YYYY-MM') = '2022-01'
    ) 
)
select writeoffs.nomenclature_ref,
       shop_ref,
       amount, 
       price_per_one,
       "date"
from writeoffs, temp_table
where writeoffs.nomenclature_ref = temp_table.nomenclature_ref
order by "date"

# 3

select nomenclature_ref, median_amount
from (
    select nomenclature_ref, percentile_disc(0.5) WITHIN GROUP (ORDER BY amount) as median_amount
    from invoice
    where shop_ref = 'fd2131d2-dca1-4dc9-8f8c-dfdd30df4b99'
    GROUP BY nomenclature_ref
) t
order by median_amount

# 4

select * 
from sales
where "date" = '2022-01-01' and
    shop_ref = '50f1c8e3-1f9c-4c29-b097-09c46a63f7d3'
order by "date", price_per_one * amount

# 5

select *
from users
order by RIGHT(name, 1)