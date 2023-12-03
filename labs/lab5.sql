-- Active: 1698192534173@@127.0.0.1@8880@db_lab

# 1

select to_char("date", 'YYYY-MM'), shop.name, sum(price_per_one*amount),
      row_number() over (partition by to_char("date", 'YYYY-MM') order by sum(price_per_one*amount) desc)
from sales
join shop on sales.shop_ref = shop.id
group by to_char("date", 'YYYY-MM'), shop.name

# 2

select *
from (
    select to_char("date", 'YYYY-MM'), nomenclature.name, sum(price_per_one*amount),
        row_number() over (partition by to_char("date", 'YYYY-MM') order by sum(price_per_one*amount) desc) as i
    from sales
    join nomenclature on sales.nomenclature_ref = nomenclature.id
    group by to_char("date", 'YYYY-MM'), nomenclature.name
) t
where i < 4

# 3

select *
from (
    select to_char("date", 'YYYY-MM'), 
        shop_ref,
        responsible_ref, 
        sum(price_per_one*amount),
        row_number() over (partition by to_char("date", 'YYYY-MM'), shop_ref order by sum(price_per_one*amount)) as i
    from sales
    group by to_char("date", 'YYYY-MM'), shop_ref, responsible_ref
    order by to_char("date", 'YYYY-MM'), shop_ref, i, responsible_ref
) t
where i < 6

# 4

select * 
from (
    select to_char("date", 'YYYY-MM'), 
        shop_ref,
        nomenclature_ref,
        sum(price_per_one*amount),
        row_number() over (partition by to_char("date", 'YYYY-MM'), shop_ref order by sum(price_per_one*amount) desc) as i
    from sales
    group by to_char("date", 'YYYY-MM'), shop_ref, nomenclature_ref
    order by to_char("date", 'YYYY-MM'), shop_ref, i, nomenclature_ref
) t
where i=1

# 5

select d, n, s, s/sum(s) over (partition by d) as "p"
from (
    select to_char(s.date, 'YYYY-MM') as d,
            s.shop_ref as n, 
            sum(s.price_per_one*s.amount) - sum(w.price_per_one*w.amount) as s
    from sales as s, invoice as w
    where s.date = w.date and 
            s.shop_ref = w.shop_ref
    group by to_char(s.date, 'YYYY-MM'), s.shop_ref
) t
order by d, n, s desc