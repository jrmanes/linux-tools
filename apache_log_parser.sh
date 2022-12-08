#!/usr/bin/env bash
LOG_FILE="$1"
LIMIT="10"

# Check if the file exists, it not, stop the process.
if [[ ! -f ${LOG_FILE} ]];then
    echo "Selected file doesn't exists... [${LOG_FILE}]"
    exit 1
fi

< "${LOG_FILE}" cut -d' ' -f4 | tr -d '[' | cut -d':' -f1 | sort | uniq -c | sort -nr | head -n "${LIMIT}"
< "${LOG_FILE}" cut -d' ' -f1 | sort | uniq -c | sort -nr | head -n "${LIMIT}"

