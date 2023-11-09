CREATE INDEX if not exists idx_sr_fee ON store_returns (sr_fee);

with customer_total_return as
(select sr_customer_sk as ctr_customer_sk
,sr_store_sk as ctr_store_sk
,sum(sr_fee) as ctr_total_return
from store_returns
inner join date_dim on sr_returned_date_sk = d_date_sk
where d_year =2000
group by sr_customer_sk
,sr_store_sk)

, avg_cust_returns as
(select ctr_store_sk as store,
avg(ctr_total_return) as avg_returns
from customer_total_return
group by ctr_store_sk)

select  c_customer_id

from customer_total_return ctr1
inner join store on s_store_sk = ctr1.ctr_store_sk
inner join customer on c_customer_sk = ctr1.ctr_customer_sk
inner join avg_cust_returns on store = ctr1.ctr_store_sk

where ctr1.ctr_total_return > 1.2*avg_returns
and s_state = 'TN'

order by c_customer_id

limit 100;