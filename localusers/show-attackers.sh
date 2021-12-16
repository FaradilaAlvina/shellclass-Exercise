#!/bin/bash

LIMIT="10"
LOG_FILE="${1}"

# Make sure a file was supplied as an arguments
if [[ ! e "${LOG_FILE}" ]]
then
  echo "Cannot open log file : ${LOG_FILE}" >&2
  exit 1
fi

# Display the csv header
grep Failed syslog-sample | awk '{print $(NF - 3)}' | sort | uniq -c | sort -nr | while read COUNT IP
do
  # If the number of failed greater than the limit, display count, IP, and location
  if [[ "${COUNT}" -gt "${LIMIT}" ]]
  then
    LOCATION=$(geoiplookup ${IP})
    echo "${COUNT}  ${IP}  ${LOCATION}"
  fi
done
exit 0


# loop through the list of failed attempts and corresponding IP addresses

# If the number of failed attempts is greater than the limit, display count, IP, and location
