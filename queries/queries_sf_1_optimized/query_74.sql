-- index on store sales
CREATE INDEX if not exists idx_ss_net_paid on store_sales(ss_net_paid);
-- index on web sales
CREATE INDEX if not exists idx_ws_net_paid on web_sales(ws_net_paid);

-- explain analyze
with store_total as (
 select c_customer_id customer_id
       ,c_first_name customer_first_name
       ,c_last_name customer_last_name
       ,d_year as year
       ,max(ss_net_paid) year_total
       ,'s' sale_type
 from customer
 inner join store_sales on c_customer_sk = ss_customer_sk
 inner join date_dim on ss_sold_date_sk = d_date_sk
 where d_year in (2001,2001+1)
 group by c_customer_id
         ,c_first_name
         ,c_last_name
         ,d_year
 ),

 web_total as(
 select c_customer_id customer_id
       ,c_first_name customer_first_name
       ,c_last_name customer_last_name
       ,d_year as year
       ,max(ws_net_paid) year_total
       ,'w' sale_type
 from customer
 inner join web_sales on c_customer_sk = ws_bill_customer_sk
 inner join date_dim on ws_sold_date_sk = d_date_sk
 where d_year in (2001,2001+1)
 group by c_customer_id
         ,c_first_name
         ,c_last_name
         ,d_year
),

t_s_firstyear as(
    select customer_id,
           customer_first_name,
           customer_last_name,
           year_total
    from store_total
    where year= 2001
    and year_total>0
),

t_s_secyear as(
    select customer_id,
           customer_first_name,
           customer_last_name,
           year_total
    from store_total
    where year= 2001+1
),

t_w_firstyear as(
    select customer_id,
           customer_first_name,
           customer_last_name,
           year_total
    from web_total
    where year= 2001
    and year_total>0
),

t_w_secyear as(
    select customer_id,
           customer_first_name,
           customer_last_name,
           year_total
    from web_total
    where year= 2001+1
)
 select
        t_s_secyear.customer_id,
        t_s_secyear.customer_first_name,
        t_s_secyear.customer_last_name

 from t_s_firstyear
 inner join t_s_secyear on t_s_secyear.customer_id = t_s_firstyear.customer_id
 inner join t_w_firstyear on t_s_firstyear.customer_id = t_w_firstyear.customer_id
 inner join t_w_secyear on t_s_firstyear.customer_id = t_w_secyear.customer_id

 where
     case when t_w_firstyear.year_total > 0 then t_w_secyear.year_total / t_w_firstyear.year_total else null end
         > case when t_s_firstyear.year_total > 0 then t_s_secyear.year_total / t_s_firstyear.year_total else null end

 order by 2,1,3

limit 100;