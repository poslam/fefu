-- Active: 1698192534173@@127.0.0.1@8880@db

# 1

select "date" as "дата", 
       shop.name as "название магазина", 
       nomenclature.name as "название товара",
       (amount * price_per_one) as "сумма"
from sales
join shop on sales.shop_ref = shop.id
join nomenclature on sales.nomenclature_ref = nomenclature.id
order by "дата", "сумма"

# 2

select date as дата, 
       shop.name as "название магазина", 
       nomenclature.name as "название товара",
       amount as количество,
       (amount * price_per_one) as сумма
from writeoffs
join shop on writeoffs.shop_ref = shop.id
join nomenclature on writeoffs.nomenclature_ref = nomenclature.id
order by количество

# 3

select date as дата, 
       shop.name as "название магазина", 
       nomenclature.name as "название товара",
       amount as количество,
       price_per_one as цена,
       (amount * price_per_one) as стоимость,
       users.name as продавец
from invoice
join shop on invoice.shop_ref = shop.id
join nomenclature on invoice.nomenclature_ref = nomenclature.id
join users on invoice.responsible_ref = users.id
order by стоимость, продавец

# 4

select 
(
  select sum(amount * price_per_one)
  from sales
  where 
    "date" = '2022-01-02' and 
    shop_ref = '266b2481-9c81-4f39-88d5-e55be2339302' and 
    nomenclature_ref = '4ef11378-7012-48a9-9228-c6898aa1ea64'
)
-
(
  select sum(amount * price_per_one)
  from invoice
  where 
    "date" = '2022-01-02' and 
    shop_ref = '266b2481-9c81-4f39-88d5-e55be2339302' and 
    nomenclature_ref = '4ef11378-7012-48a9-9228-c6898aa1ea64'
)


# 5
with temp_table (name) as (
       select "name"
       from users
       where id = '06d60edf-13e3-4c0e-b84e-a14c73dda762'
)
select "date", sum(amount * price_per_one), temp_table.name
from sales, temp_table
where responsible_ref = '06d60edf-13e3-4c0e-b84e-a14c73dda762'
      and shop_ref = '266b2481-9c81-4f39-88d5-e55be2339302'
      and to_char("date", 'YYYY-MM') = '2022-01'
group by "date", temp_table.name