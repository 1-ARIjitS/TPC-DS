-- index on store sales
CREATE INDEX if not exists idx_ss_ext_list_price on store_sales(ss_ext_list_price);
CREATE INDEX if not exists idx_ss_ext_wholesale_cost on store_sales(ss_ext_wholesale_cost);
CREATE INDEX if not exists idx_ss_ext_discount_amt on store_sales(ss_ext_discount_amt);
CREATE INDEX if not exists idx_ss_ext_sales_price on store_sales(ss_ext_sales_price);
-- index on web sales
CREATE INDEX if not exists idx_ws_ext_list_price on web_sales(ws_ext_list_price);
CREATE INDEX if not exists idx_ws_ext_wholesale_cost on web_sales(ws_ext_wholesale_cost);
CREATE INDEX if not exists idx_ws_ext_discount_amt on web_sales(ws_ext_discount_amt);
CREATE INDEX if not exists idx_ws_ext_sales_price on web_sales(ws_ext_sales_price);

-- explain analyze
with store_total as (
 select c_customer_id customer_id
       ,c_first_name customer_first_name
       ,c_last_name customer_last_name
       ,c_preferred_cust_flag customer_preferred_cust_flag
       ,c_birth_country customer_birth_country
       ,c_login customer_login
       ,c_email_address customer_email_address
       ,d_year dyear
       ,sum(ss_ext_list_price-ss_ext_discount_amt) year_total
       ,'s' sale_type
 from customer
 inner join store_sales on c_customer_sk = ss_customer_sk
 inner join date_dim on ss_sold_date_sk = d_date_sk
 group by c_customer_id
         ,c_first_name
         ,c_last_name
         ,c_preferred_cust_flag
         ,c_birth_country
         ,c_login
         ,c_email_address
         ,d_year
),

web_total as(
 select c_customer_id customer_id
       ,c_first_name customer_first_name
       ,c_last_name customer_last_name
       ,c_preferred_cust_flag customer_preferred_cust_flag
       ,c_birth_country customer_birth_country
       ,c_login customer_login
       ,c_email_address customer_email_address
       ,d_year dyear
       ,sum(ws_ext_list_price-ws_ext_discount_amt) year_total
       ,'w' sale_type
 from customer
 inner join web_sales on c_customer_sk = ws_bill_customer_sk
 inner join date_dim on ws_sold_date_sk = d_date_sk
 group by c_customer_id
         ,c_first_name
         ,c_last_name
         ,c_preferred_cust_flag
         ,c_birth_country
         ,c_login
         ,c_email_address
         ,d_year
),

t_s_firstyear as(
    select customer_id,
           customer_first_name,
           customer_last_name,
           customer_email_address,
           year_total
    from store_total
    where dyear= 2001
    and year_total>0
),

t_s_secyear as(
    select customer_id,
           customer_first_name,
           customer_last_name,
           customer_email_address,
           year_total
    from store_total
    where dyear= 2001+1
),

t_w_firstyear as(
    select customer_id,
           customer_first_name,
           customer_last_name,
           customer_email_address,
           year_total
    from web_total
    where dyear= 2001
    and year_total>0
),

t_w_secyear as(
    select customer_id,
           customer_first_name,
           customer_last_name,
           customer_email_address,
           year_total
    from web_total
    where dyear= 2001+1
)

select
t_s_secyear.customer_id
,t_s_secyear.customer_first_name
,t_s_secyear.customer_last_name
,t_s_secyear.customer_email_address

from t_s_firstyear
inner join t_s_secyear on t_s_secyear.customer_id = t_s_firstyear.customer_id
inner join t_w_firstyear on t_s_firstyear.customer_id = t_w_firstyear.customer_id
inner join t_w_secyear on t_s_firstyear.customer_id = t_w_secyear.customer_id

where
     case when t_w_firstyear.year_total > 0 then t_w_secyear.year_total / t_w_firstyear.year_total else 0.0 end
         > case when t_s_firstyear.year_total > 0 then t_s_secyear.year_total / t_s_firstyear.year_total else 0.0 end

order by t_s_secyear.customer_id
         ,t_s_secyear.customer_first_name
         ,t_s_secyear.customer_last_name
         ,t_s_secyear.customer_email_address

limit 100;