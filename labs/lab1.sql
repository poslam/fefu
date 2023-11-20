-- Active: 1684072589968@@127.0.0.1@8880@db

# 2

select * 
from sales
where "date"='2022-02-19';

# 3

select *
from writeoffs
limit 100;

# 4

select DISTINCT "date"
from sales;

# 5


select max(amount * price_per_one) as "Максимальная сумма",
       min(amount * price_per_one) as "Минимальная сумма",
       count(amount) as num
from sales
