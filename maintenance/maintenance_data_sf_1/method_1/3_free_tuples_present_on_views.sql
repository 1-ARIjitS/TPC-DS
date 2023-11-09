-- Mapping the VIEWs to TABLEs:
-- crv -> catalog_returns
-- csv -> catalog_sales
-- iv  -> inventory
-- srv -> store_returns
-- ssv -> store_sales
-- wrv -> web_returns
-- wsv -> web_sales

-- First we will delete the data based on the primary key of each table:
DELETE FROM catalog_returns
WHERE (cr_item_sk, cr_order_number) IN (
    SELECT DISTINCT crv.cr_item_sk, crv.cr_order_number FROM crv
);

DELETE FROM catalog_sales
WHERE (cs_item_sk, cs_order_number) IN (
    SELECT DISTINCT csv.cs_item_sk, csv.cs_order_number FROM csv
);

DELETE FROM inventory
WHERE (inv_date_sk, inv_item_sk, inv_warehouse_sk) IN (
    SELECT DISTINCT iv.inv_date_sk, iv.inv_item_sk, iv.inv_warehouse_sk FROM iv
);

DELETE FROM store_returns
WHERE (sr_item_sk, sr_ticket_number) IN (
    SELECT DISTINCT srv.sr_item_sk, srv.sr_ticket_number FROM srv
);

DELETE FROM store_sales
WHERE (ss_item_sk, ss_ticket_number) IN (
    SELECT DISTINCT ssv.ss_item_sk, ssv.ss_ticket_number FROM ssv
);

DELETE FROM web_returns
WHERE (wr_item_sk, wr_order_number) IN (
    SELECT DISTINCT wrv.wr_item_sk, wrv.wr_order_number FROM wrv
);

DELETE FROM web_sales
WHERE (ws_item_sk, ws_order_number) IN (
    SELECT DISTINCT wsv.ws_item_sk, wsv.ws_order_number FROM wsv
);
