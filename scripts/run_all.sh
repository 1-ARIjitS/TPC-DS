#!/usr/bin/env bash
# Usage instructions:
# Modify all the paths here accordingly.
# Avoid using relative paths for safety.
# Execute `./run_all.sh <SF>` from inside the `scripts` folder.
# <SF> is the scale factor used to run the tests.

set -eu

# Check if exactly 2 arguments are provided
# if [ "$#" -ne 2 ]; then
#   echo "Usage: $0 <SCALE_FACTOR> <NUM_RUNS>"
#   exit 1
# fi

SCALE_FACTOR="$1"
# NUM_RUNS=${1}

ROOT_PATH=$(wslpath "D:/TPC-DS/DW_project")
DATA_PATH=$(wslpath "D:/TPC-DS/DW_project/Copy_data/data")
CREATE_TABLES_FILE=$(wslpath "D:/TPC-DS/DW_project/tools/tpcds.sql")
QUERY_FILES_PATH=$(wslpath "D:/TPC-DS/DW_project/queries/queries")
MAINTENANCE_QUERY_FILES_PATH=$(wslpath "D:/TPC-DS/DW_project/maintenance/maintenance_data")

ROOT_PATH="${ROOT_PATH}/Results_SF_${SCALE_FACTOR}"
DATA_PATH="${DATA_PATH}_sf_${SCALE_FACTOR}.sql"
QUERY_FILES_PATH="${QUERY_FILES_PATH}_sf_${SCALE_FACTOR}_optimized"
MAINTENANCE_QUERY_FILES_PATH="${MAINTENANCE_QUERY_FILES_PATH}_sf_${SCALE_FACTOR}"

# for ((i = 1; i<=2; i++)); do
# python3 ./load_test.py -rp ${ROOT_PATH} -dp ${DATA_PATH} -ct ${CREATE_TABLES_FILE} -sf ${SCALE_FACTOR}
# python3 ./power_test.py -rp ${ROOT_PATH} -qp ${QUERY_FILES_PATH} -sf ${SCALE_FACTOR}
python3 ./throughput_test.py -rp ${ROOT_PATH} -qp ${QUERY_FILES_PATH} -sf ${SCALE_FACTOR}
python3 ./maintenance_test.py -rp ${ROOT_PATH} -mp ${MAINTENANCE_QUERY_FILES_PATH} -sf ${SCALE_FACTOR}
python3 ./throughput_test.py -rp ${ROOT_PATH} -qp ${QUERY_FILES_PATH} -sf ${SCALE_FACTOR}
python3 ./maintenance_test.py -rp ${ROOT_PATH} -mp ${MAINTENANCE_QUERY_FILES_PATH} -sf ${SCALE_FACTOR}
python3 ./db_postprocess.py -rp ${ROOT_PATH} -sf ${SCALE_FACTOR}
# done



1. Load test

2. Power test

3. Throughput test 1

4. Maintenance test 1

5. Thrughput test2

6. Maintenance test 2

7. DB postprocessing