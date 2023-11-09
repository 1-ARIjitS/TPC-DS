CREATE INDEX if not exists idx_item_current_price on item(i_current_price);

with avg_price as(
select i.i_category, avg(i.i_current_price) as avg
from item i
group by i.i_category
)

select  a.ca_state state, count(*) cnt
from customer_address a
inner join customer c on a.ca_address_sk = c.c_current_addr_sk
inner join store_sales s on c.c_customer_sk = s.ss_customer_sk
inner join date_dim d on s.ss_sold_date_sk = d.d_date_sk
inner join item i on s.ss_item_sk = i.i_item_sk
inner join avg_price on i.i_category= avg_price.i_category

where d.d_year= 2000
and d.d_moy= 2
and i.i_current_price > 1.2 * avg_price.avg
 
group by a.ca_state
having count(*) >= 10

order by cnt, a.ca_state

limit 100;