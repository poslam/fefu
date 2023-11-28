-- Active: 1698192534173@@127.0.0.1@8880@db_lab

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


select "date", shop_ref, responsible_ref, max("sum") 
from (
    select  "date", shop_ref, responsible_ref,
            sum(price_per_one*amount) over (partition by "date", shop_ref, responsible_ref)
    from sales
) t
group by "date", shop_ref, responsible_ref


# 3

select "date", shop_ref, responsible_ref, "max", "min", "max"-"min" as profit
from (
    select "date", shop_ref, responsible_ref, sales_sum as "max", writeoffs_sum as "min",
        row_number() over (partition by "date", shop_ref order by sales_sum desc, writeoffs_sum) as i
    from (
        select s.date, s.shop_ref, s.responsible_ref,
                sum(s.price_per_one*s.amount) over (partition by s.date, s.shop_ref, s.responsible_ref) as sales_sum,
                sum(w.price_per_one*w.amount) over (partition by w.date, w.shop_ref, w.responsible_ref) as writeoffs_sum
        from sales as s, writeoffs as w
        where s.date = w.date and 
                s.shop_ref = w.shop_ref and
                s.responsible_ref = w.responsible_ref
    ) t
) t
where t.i = 1
order by "date", shop_ref, responsible_ref


# 4

with temp1 ("month", income) as (
    select to_char("date", 'MONTHYYYY'), 
           sum(price_per_one*amount)
    from sales
    group by to_char("date", 'MONTHYYYY')
),
temp2 (m, s, d, perc) as (
    select to_char("date", 'MONTHYYYY'), 
           shop_ref,
           to_char("date", 'DY'),
           sum(price_per_one*amount) / income as "m"
    from sales, temp1
    where temp1.month = to_char("date", 'MONTHYYYY')
    group by to_char("date", 'MONTHYYYY'), shop_ref, to_char("date", 'DY'), income
),
temp3 (m, s, max) as (
    select "m", s, max(perc)
    from temp2, temp1
    where temp2.m = temp1.month
    group by "m", s
)
select temp3.m as "Месяц", 
       temp3.s as "Название магазина", 
       temp2.d as "День недели", 
       temp3.max as "Доля продаж"
from temp2, temp3
where temp2.m = temp3.m and
      temp2.s = temp3.s and
      temp2.perc = temp3.max
order by temp3.m, temp3.s, temp2.d, temp3.max

# 5

with temp (s, d, su) as (
    with "money" as (
        select "date",
            shop_ref,
            price_per_one * amount as income
        from sales
    )
    select shop_ref,
        "date",
        sum(income)
    from "money"
    group by shop_ref, "date"
)
select s as "Название магазина",
       d as "Дата", 
       su as "Доход за день", 
       1.0*sum(su) over(partition by s order by d) as "Доход с начала месяца"
from temp