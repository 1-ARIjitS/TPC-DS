COPY s_purchase_lineitem FROM 'D:/TPC-DS/DW_project/Data/maintenance_data_sf_1/s_purchase_lineitem_1_4.dat' DELIMITER '|' NULL '' ENCODING 'LATIN1';
COPY s_purchase FROM 'D:/TPC-DS/DW_project/Data/maintenance_data_sf_1/s_purchase_1_4.dat' DELIMITER '|' NULL '' ENCODING 'LATIN1';
COPY s_catalog_order FROM 'D:/TPC-DS/DW_project/Data/maintenance_data_sf_1/s_catalog_order_1_4.dat' DELIMITER '|' NULL '' ENCODING 'LATIN1';
COPY s_web_order FROM 'D:/TPC-DS/DW_project/Data/maintenance_data_sf_1/s_web_order_1_4.dat' DELIMITER '|' NULL '' ENCODING 'LATIN1';
COPY s_catalog_order_lineitem FROM 'D:/TPC-DS/DW_project/Data/maintenance_data_sf_1/s_catalog_order_lineitem_1_4.dat' DELIMITER '|' NULL '' ENCODING 'LATIN1';
COPY s_web_order_lineitem FROM 'D:/TPC-DS/DW_project/Data/maintenance_data_sf_1/s_web_order_lineitem_1_4.dat' DELIMITER '|' NULL '' ENCODING 'LATIN1';
COPY s_store_returns FROM 'D:/TPC-DS/DW_project/Data/maintenance_data_sf_1/s_store_returns_1_4.dat' DELIMITER '|' NULL '' ENCODING 'LATIN1';
COPY s_catalog_returns FROM 'D:/TPC-DS/DW_project/Data/maintenance_data_sf_1/s_catalog_returns_1_4.dat' DELIMITER '|' NULL '' ENCODING 'LATIN1';
COPY s_inventory FROM 'D:/TPC-DS/DW_project/Data/maintenance_data_sf_1/s_inventory_1_4.dat' DELIMITER '|' NULL '' ENCODING 'LATIN1';
COPY s_web_returns FROM 'D:/TPC-DS/DW_project/Data/maintenance_data_sf_1/s_web_returns_1_4.dat' DELIMITER '|' NULL '' ENCODING 'LATIN1';


