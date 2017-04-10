#!/usr/bin/env bash
set -ueo pipefail

OUTPUT_DIR="$1"
INPUT_DIR="$2"
echo "OUTPUT: $OUTPUT_DIR"
echo "INPUT: $INPUT_DIR"

java -cp \
    /opt/solr-6.2.1/server/solr-webapp/webapp/WEB-INF/lib/lucene-core-6.2.1.jar:/opt/solr-6.2.1/server/solr-webapp/webapp/WEB-INF/lib/lucene-misc-6.2.1.jar \
    org/apache/lucene/misc/IndexMergeTool \
    $OUTPUT_DIR \
    ${INPUT_DIR}/index-*
