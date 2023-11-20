
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
       sum(su) over(partition by s order by d) as "Доход с начала месяца"
from temp


select 148853150 + 427165900 - 576019100