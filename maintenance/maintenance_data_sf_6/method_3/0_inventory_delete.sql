DELETE FROM inventory WHERE inv_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '2000-05-18' AND d.d_date <= '2000-05-25
');

DELETE FROM inventory WHERE inv_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '1999-09-16' AND d.d_date <= '1999-09-23
');

DELETE FROM inventory WHERE inv_date_sk IN
(SELECT DISTINCT d_date_sk
FROM date_dim d
WHERE d.d_date >= '2002-11-14' AND d.d_date <= '2002-11-21
');

