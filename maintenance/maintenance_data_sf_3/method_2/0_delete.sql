DELETE FROM catalog_sales WHERE cs_sold_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '2000-05-20' AND d.d_date <= '2000-05-21
');

DELETE FROM catalog_returns WHERE cr_returned_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '2000-05-20' AND d.d_date <= '2000-05-21
');

DELETE FROM store_sales WHERE ss_sold_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '2000-05-20' AND d.d_date <= '2000-05-21
');

DELETE FROM store_returns WHERE sr_returned_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '2000-05-20' AND d.d_date <= '2000-05-21
');

DELETE FROM web_sales WHERE ws_sold_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '2000-05-20' AND d.d_date <= '2000-05-21
');

DELETE FROM web_returns WHERE wr_returned_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '2000-05-20' AND d.d_date <= '2000-05-21
');


DELETE FROM catalog_sales WHERE cs_sold_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '1999-09-18' AND d.d_date <= '1999-09-19
');

DELETE FROM catalog_returns WHERE cr_returned_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '1999-09-18' AND d.d_date <= '1999-09-19
');

DELETE FROM store_sales WHERE ss_sold_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '1999-09-18' AND d.d_date <= '1999-09-19
');

DELETE FROM store_returns WHERE sr_returned_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '1999-09-18' AND d.d_date <= '1999-09-19
');

DELETE FROM web_sales WHERE ws_sold_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '1999-09-18' AND d.d_date <= '1999-09-19
');

DELETE FROM web_returns WHERE wr_returned_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '1999-09-18' AND d.d_date <= '1999-09-19
');


DELETE FROM catalog_sales WHERE cs_sold_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '2002-11-12' AND d.d_date <= '2002-11-13
');

DELETE FROM catalog_returns WHERE cr_returned_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '2002-11-12' AND d.d_date <= '2002-11-13
');

DELETE FROM store_sales WHERE ss_sold_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '2002-11-12' AND d.d_date <= '2002-11-13
');

DELETE FROM store_returns WHERE sr_returned_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '2002-11-12' AND d.d_date <= '2002-11-13
');

DELETE FROM web_sales WHERE ws_sold_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '2002-11-12' AND d.d_date <= '2002-11-13
');

DELETE FROM web_returns WHERE wr_returned_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '2002-11-12' AND d.d_date <= '2002-11-13
');


