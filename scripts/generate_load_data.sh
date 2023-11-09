#!/usr/bin/env bash

SCALE_FACTOR=${1}

DATA_DIR="/mnt/d/TPC-DS/DW_project/Data/data_sf_${SCALE_FACTOR}"
OUTPUT_SCRIPT_PATH="/mnt/d/TPC-DS/DW_project/Copy_data/data_sf_${SCALE_FACTOR}.sql"

if [ -f ${OUTPUT_SCRIPT_PATH} ]; then
    echo "Found a previous ${OUTPUT_SCRIPT_PATH}"
    rm -i ${OUTPUT_SCRIPT_PATH}
fi

for file in ${DATA_DIR}/*
do
    echo "Adding file ${file}..."

    NO_EXTENSION=${file::-8}
    TABLE=${NO_EXTENSION##*/}
    # There are multiple possible encodings for ISO-8859.
    # Let's try to use the LATIN1 one.
    # https://www.postgresql.org/docs/current/multibyte.html#MULTIBYTE-CHARSET-SUPPORTED
    COMMAND="COPY ${TABLE} FROM '${file}' DELIMITER '|' NULL '' ENCODING 'LATIN1';"

    echo "${COMMAND}" >> ${OUTPUT_SCRIPT_PATH}
done

echo "Done!"

