INSERT INTO catalog_returns  SELECT * FROM crv WHERE cr_item_sk IS NOT NULL ON CONFLICT (cr_item_sk, cr_order_number) DO UPDATE SET
    cr_returned_date_sk       = excluded.cr_returned_date_sk,
    cr_returned_time_sk       = excluded.cr_returned_time_sk,
    cr_refunded_customer_sk   = excluded.cr_refunded_customer_sk,
    cr_refunded_cdemo_sk      = excluded.cr_refunded_cdemo_sk,
    cr_refunded_hdemo_sk      = excluded.cr_refunded_hdemo_sk,
    cr_refunded_addr_sk       = excluded.cr_refunded_addr_sk,
    cr_returning_customer_sk  = excluded.cr_returning_customer_sk,
    cr_returning_cdemo_sk     = excluded.cr_returning_cdemo_sk,
    cr_returning_hdemo_sk     = excluded.cr_returning_hdemo_sk,
    cr_returning_addr_sk      = excluded.cr_returning_addr_sk,
    cr_call_center_sk         = excluded.cr_call_center_sk,
    cr_catalog_page_sk        = excluded.cr_catalog_page_sk,
    cr_ship_mode_sk           = excluded.cr_ship_mode_sk,
    cr_warehouse_sk           = excluded.cr_warehouse_sk,
    cr_reason_sk              = excluded.cr_reason_sk,
    cr_return_quantity        = excluded.cr_return_quantity,
    cr_return_amount          = excluded.cr_return_amount,
    cr_return_tax             = excluded.cr_return_tax,
    cr_return_amt_inc_tax     = excluded.cr_return_amt_inc_tax,
    cr_fee                    = excluded.cr_fee,
    cr_return_ship_cost       = excluded.cr_return_ship_cost,
    cr_refunded_cash          = excluded.cr_refunded_cash,
    cr_reversed_charge        = excluded.cr_reversed_charge,
    cr_store_credit           = excluded.cr_store_credit,
    cr_net_loss               = excluded.cr_net_loss
;


INSERT INTO catalog_sales   SELECT * FROM csv WHERE cs_item_sk IS NOT NULL ON CONFLICT (cs_item_sk, cs_order_number) DO UPDATE SET
    cs_sold_date_sk           = excluded.cs_sold_date_sk,
    cs_sold_time_sk           = excluded.cs_sold_time_sk,
    cs_ship_date_sk           = excluded.cs_ship_date_sk,
    cs_bill_customer_sk       = excluded.cs_bill_customer_sk,
    cs_bill_cdemo_sk          = excluded.cs_bill_cdemo_sk,
    cs_bill_hdemo_sk          = excluded.cs_bill_hdemo_sk,
    cs_bill_addr_sk           = excluded.cs_bill_addr_sk,
    cs_ship_customer_sk       = excluded.cs_ship_customer_sk,
    cs_ship_cdemo_sk          = excluded.cs_ship_cdemo_sk,
    cs_ship_hdemo_sk          = excluded.cs_ship_hdemo_sk,
    cs_ship_addr_sk           = excluded.cs_ship_addr_sk,
    cs_call_center_sk         = excluded.cs_call_center_sk,
    cs_catalog_page_sk        = excluded.cs_catalog_page_sk,
    cs_ship_mode_sk           = excluded.cs_ship_mode_sk,
    cs_warehouse_sk           = excluded.cs_warehouse_sk,
    cs_promo_sk               = excluded.cs_promo_sk,
    cs_quantity               = excluded.cs_quantity,
    cs_wholesale_cost         = excluded.cs_wholesale_cost,
    cs_list_price             = excluded.cs_list_price,
    cs_sales_price            = excluded.cs_sales_price,
    cs_ext_discount_amt       = excluded.cs_ext_discount_amt,
    cs_ext_sales_price        = excluded.cs_ext_sales_price,
    cs_ext_wholesale_cost     = excluded.cs_ext_wholesale_cost,
    cs_ext_list_price         = excluded.cs_ext_list_price,
    cs_ext_tax                = excluded.cs_ext_tax,
    cs_coupon_amt             = excluded.cs_coupon_amt,
    cs_ext_ship_cost          = excluded.cs_ext_ship_cost,
    cs_net_paid               = excluded.cs_net_paid,
    cs_net_paid_inc_tax       = excluded.cs_net_paid_inc_tax,
    cs_net_paid_inc_ship      = excluded.cs_net_paid_inc_ship,
    cs_net_paid_inc_ship_tax  = excluded.cs_net_paid_inc_ship_tax,
    cs_net_profit             = excluded.cs_net_profit
;


INSERT INTO inventory       SELECT * FROM iv WHERE inv_item_sk IS NOT NULL ON CONFLICT (inv_date_sk, inv_item_sk, inv_warehouse_sk) DO UPDATE SET
    inv_quantity_on_hand      = excluded.inv_quantity_on_hand
;



INSERT INTO store_returns   SELECT * FROM srv WHERE sr_item_sk IS NOT NULL ON CONFLICT (sr_item_sk, sr_ticket_number) DO UPDATE SET
    sr_returned_date_sk       = excluded.sr_returned_date_sk,
    sr_return_time_sk         = excluded.sr_return_time_sk,
    sr_customer_sk            = excluded.sr_customer_sk,
    sr_cdemo_sk               = excluded.sr_cdemo_sk,
    sr_hdemo_sk               = excluded.sr_hdemo_sk,
    sr_addr_sk                = excluded.sr_addr_sk,
    sr_store_sk               = excluded.sr_store_sk,
    sr_reason_sk              = excluded.sr_reason_sk,
    sr_return_quantity        = excluded.sr_return_quantity,
    sr_return_amt             = excluded.sr_return_amt,
    sr_return_tax             = excluded.sr_return_tax,
    sr_return_amt_inc_tax     = excluded.sr_return_amt_inc_tax,
    sr_fee                    = excluded.sr_fee,
    sr_return_ship_cost       = excluded.sr_return_ship_cost,
    sr_refunded_cash          = excluded.sr_refunded_cash,
    sr_reversed_charge        = excluded.sr_reversed_charge,
    sr_store_credit           = excluded.sr_store_credit,
    sr_net_loss               = excluded.sr_net_loss
;



INSERT INTO store_sales     SELECT * FROM ssv WHERE ss_item_sk IS NOT NULL ON CONFLICT (ss_item_sk, ss_ticket_number) DO UPDATE SET
    ss_sold_date_sk           = excluded.ss_sold_date_sk,
    ss_sold_time_sk           = excluded.ss_sold_time_sk,
    ss_customer_sk            = excluded.ss_customer_sk,
    ss_cdemo_sk               = excluded.ss_cdemo_sk,
    ss_hdemo_sk               = excluded.ss_hdemo_sk,
    ss_addr_sk                = excluded.ss_addr_sk,
    ss_store_sk               = excluded.ss_store_sk,
    ss_promo_sk               = excluded.ss_promo_sk,
    ss_quantity               = excluded.ss_quantity,
    ss_wholesale_cost         = excluded.ss_wholesale_cost,
    ss_list_price             = excluded.ss_list_price,
    ss_sales_price            = excluded.ss_sales_price,
    ss_ext_discount_amt       = excluded.ss_ext_discount_amt,
    ss_ext_sales_price        = excluded.ss_ext_sales_price,
    ss_ext_wholesale_cost     = excluded.ss_ext_wholesale_cost,
    ss_ext_list_price         = excluded.ss_ext_list_price,
    ss_ext_tax                = excluded.ss_ext_tax,
    ss_coupon_amt             = excluded.ss_coupon_amt,
    ss_net_paid               = excluded.ss_net_paid,
    ss_net_paid_inc_tax       = excluded.ss_net_paid_inc_tax,
    ss_net_profit             = excluded.ss_net_profit
;


INSERT INTO web_returns     SELECT * FROM wrv WHERE wr_item_sk IS NOT NULL ON CONFLICT (wr_item_sk, wr_order_number) DO UPDATE SET
    wr_returned_date_sk       = excluded.wr_returned_date_sk,
    wr_returned_time_sk       = excluded.wr_returned_time_sk,
    wr_refunded_customer_sk   = excluded.wr_refunded_customer_sk,
    wr_refunded_cdemo_sk      = excluded.wr_refunded_cdemo_sk,
    wr_refunded_hdemo_sk      = excluded.wr_refunded_hdemo_sk,
    wr_refunded_addr_sk       = excluded.wr_refunded_addr_sk,
    wr_returning_customer_sk  = excluded.wr_returning_customer_sk,
    wr_returning_cdemo_sk     = excluded.wr_returning_cdemo_sk,
    wr_returning_hdemo_sk     = excluded.wr_returning_hdemo_sk,
    wr_returning_addr_sk      = excluded.wr_returning_addr_sk,
    wr_web_page_sk            = excluded.wr_web_page_sk,
    wr_reason_sk              = excluded.wr_reason_sk,
    wr_return_quantity        = excluded.wr_return_quantity,
    wr_return_amt             = excluded.wr_return_amt,
    wr_return_tax             = excluded.wr_return_tax,
    wr_return_amt_inc_tax     = excluded.wr_return_amt_inc_tax,
    wr_fee                    = excluded.wr_fee,
    wr_return_ship_cost       = excluded.wr_return_ship_cost,
    wr_refunded_cash          = excluded.wr_refunded_cash,
    wr_reversed_charge        = excluded.wr_reversed_charge,
    wr_account_credit         = excluded.wr_account_credit,
    wr_net_loss               = excluded.wr_net_loss
;



INSERT INTO web_sales       SELECT * FROM wsv WHERE ws_item_sk IS NOT NULL ON CONFLICT (ws_item_sk, ws_order_number) DO UPDATE SET
    ws_sold_date_sk           = excluded.ws_sold_date_sk,
    ws_sold_time_sk           = excluded.ws_sold_time_sk,
    ws_ship_date_sk           = excluded.ws_ship_date_sk,
    ws_bill_customer_sk       = excluded.ws_bill_customer_sk,
    ws_bill_cdemo_sk          = excluded.ws_bill_cdemo_sk,
    ws_bill_hdemo_sk          = excluded.ws_bill_hdemo_sk,
    ws_bill_addr_sk           = excluded.ws_bill_addr_sk,
    ws_ship_customer_sk       = excluded.ws_ship_customer_sk,
    ws_ship_cdemo_sk          = excluded.ws_ship_cdemo_sk,
    ws_ship_hdemo_sk          = excluded.ws_ship_hdemo_sk,
    ws_ship_addr_sk           = excluded.ws_ship_addr_sk,
    ws_web_page_sk            = excluded.ws_web_page_sk,
    ws_web_site_sk            = excluded.ws_web_site_sk,
    ws_ship_mode_sk           = excluded.ws_ship_mode_sk,
    ws_warehouse_sk           = excluded.ws_warehouse_sk,
    ws_promo_sk               = excluded.ws_promo_sk,
    ws_quantity               = excluded.ws_quantity,
    ws_wholesale_cost         = excluded.ws_wholesale_cost,
    ws_list_price             = excluded.ws_list_price,
    ws_sales_price            = excluded.ws_sales_price,
    ws_ext_discount_amt       = excluded.ws_ext_discount_amt,
    ws_ext_sales_price        = excluded.ws_ext_sales_price,
    ws_ext_wholesale_cost     = excluded.ws_ext_wholesale_cost,
    ws_ext_list_price         = excluded.ws_ext_list_price,
    ws_ext_tax                = excluded.ws_ext_tax,
    ws_coupon_amt             = excluded.ws_coupon_amt,
    ws_ext_ship_cost          = excluded.ws_ext_ship_cost,
    ws_net_paid               = excluded.ws_net_paid,
    ws_net_paid_inc_tax       = excluded.ws_net_paid_inc_tax,
    ws_net_paid_inc_ship      = excluded.ws_net_paid_inc_ship,
    ws_net_paid_inc_ship_tax  = excluded.ws_net_paid_inc_ship_tax,
    ws_net_profit             = excluded.ws_net_profit
;
