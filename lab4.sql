-- Active: 1689169282036@@127.0.0.1@5432@db_study

# 1

select to_char("date", 'YYYY-mm-dd') as месяц, 
       min(price_per_one*amount) as "минимальная сумма продажи",
       max(price_per_one*amount) as "максимальная сумма продажи",
       avg(price_per_one*amount) as "средняя сумма продажи",
       sum(price_per_one*amount) as "общая сумма продаж",
       count(price_per_one*amount) as "количество продаж"
from sales
group by to_char("date", 'YYYY-mm-dd')
order by to_char("date", 'YYYY-mm-dd')

# 2

with temp1 ("date", shop_ref, resp, sum) as (
    select "date", shop_ref, responsible_ref, price_per_one*amount
    from sales
),
temp2 ("date", shop_ref, sum) as (
    select "date", shop_ref, max(price_per_one*amount)
    from sales
    group by "date", shop_ref
)
select temp1.date, temp1.shop_ref, temp1.resp, temp1.sum
from temp1, temp2
where temp1.date = temp2.date and
      temp1.shop_ref = temp2.shop_ref and
      temp1.sum = temp2.sum
order by "date", shop_ref

# 3

with temp1 ("date", shop_ref, resp, max, min) as (
    select sales.date, sales.shop_ref, sales.responsible_ref, 
           sales.price_per_one*sales.amount,
           writeoffs.price_per_one*writeoffs.amount
    from sales
    left join writeoffs on sales.date = writeoffs.date and
                      sales.shop_ref = writeoffs.shop_ref and
                      sales.responsible_ref = writeoffs.responsible_ref
    order by sales.date, sales.shop_ref, sales.responsible_ref
),
temp2 ("date", shop_ref, max, min) as (
    select sales.date, sales.shop_ref, 
            max(sales.price_per_one*sales.amount),
            min(writeoffs.price_per_one*writeoffs.amount)
    from sales
    left join writeoffs on sales.date = writeoffs.date and
                    sales.shop_ref = writeoffs.shop_ref and
                    sales.responsible_ref = writeoffs.responsible_ref
    group by sales.date, sales.shop_ref
)
select temp1.date, temp1.shop_ref, temp1.resp, temp1.max, temp1.min, temp1.max - temp2.min as profit
from temp1, temp2
where temp1.date = temp2.date and 
      temp1.shop_ref = temp2.shop_ref and
      temp1.max = temp2.max and
      temp1.min = temp2.min 
order by "date", shop_ref

# 4

