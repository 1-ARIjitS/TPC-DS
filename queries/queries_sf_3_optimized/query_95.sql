CREATE INDEX if not exists idx_order_number on web_sales(ws_order_number);
CREATE INDEX if not exists idx_ext_ship_cost on web_sales(ws_ext_ship_cost);
CREATE INDEX if not exists idx_net_profit on web_sales(ws_net_profit);

with ws_wh as
(select ws1.ws_order_number,ws1.ws_warehouse_sk wh1,ws2.ws_warehouse_sk wh2
 from web_sales ws1,web_sales ws2
 where ws1.ws_order_number = ws2.ws_order_number
   and ws1.ws_warehouse_sk <> ws2.ws_warehouse_sk
),

wr as(
select wr_order_number
from web_returns
inner join ws_wh on wr_order_number = ws_wh.ws_order_number
)

select
   count(distinct ws_order_number) as "order count"
  ,sum(ws_ext_ship_cost) as "total shipping cost"
  ,sum(ws_net_profit) as "total net profit"

from
   web_sales ws1
inner join date_dim on ws1.ws_ship_date_sk = d_date_sk
inner join customer_address on ws1.ws_ship_addr_sk = ca_address_sk
inner join web_site on ws1.ws_web_site_sk = web_site_sk

where
    d_date between '1999-5-01' and
           (cast('1999-5-01' as date) + interval '60 days')
and ca_state = 'TX'
and web_company_name = 'pri'
-- and ws1.ws_order_number in (select ws_order_number from ws_wh)
and ws1.ws_order_number in (select wr.wr_order_number from wr)
order by count(distinct ws_order_number)
limit 100;