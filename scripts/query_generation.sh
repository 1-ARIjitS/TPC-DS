#!/usr/bin/env bash
# Usage instructions:
# Execute `./query_generation.sh <SF>` from inside the `scripts` folder.
# <SF> is the scale factor used to generate the queries.
# After executing it, a directory `../queries` is created containing all the 99 queries.

# This script is an adapted version of the script located at:
# https://github.com/pingcap/tidb-bench/blob/master/tpcds/genquery.sh

set -eu

SCALE="$1"
TEMPLATE_DIR="../../query_templates"
OUTPUT_DIR="./queries"
QUERY_ID=""

function generate_query()
{
    ./dsqgen \
    -DIRECTORY "$TEMPLATE_DIR" \
    -INPUT "$TEMPLATE_DIR/templates.lst" \
    -SCALE $SCALE \
    -OUTPUT_DIR $OUTPUT_DIR \
    -DIALECT netezza \
    -TEMPLATE "query$QUERY_ID.tpl"
    mv "$OUTPUT_DIR/query_0.sql" "$OUTPUT_DIR/query_$QUERY_ID.sql"
}

cd ../DSGen-software-code-3.2.0rc1/tools
rm -rf $OUTPUT_DIR
mkdir $OUTPUT_DIR

for i in {1..99}; do
    QUERY_ID="$i"
    generate_query
done

rm -rf ../../queries/sc_${1}/
mv $OUTPUT_DIR ../../queries/sc_${1}/
cd -

