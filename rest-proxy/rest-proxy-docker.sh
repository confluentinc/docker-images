#!/bin/bash

RP_CFG_FILE="/etc/kafka-rest/kafka-rest.properties"

: ${WAIT_FOR:="echo waiting for other services; sleep 1"}

# Download the config file, if given a URL
if [ ! -z "$RP_CFG_URL" ]; then
  echo "[RP] Downloading RP config file from ${RP_CFG_URL}"
  curl --location --silent --insecure --output ${RP_CFG_FILE} ${RP_CFG_URL}
  if [ $? -ne 0 ]; then
    echo "[RP] Failed to download ${RP_CFG_URL} exiting."
    exit 1
  fi
fi

/usr/bin/docker-edit-properties --file ${RP_CFG_FILE} --include 'KAFKA_REST_(.*)' --include 'RP_(.*)' --exclude '^RP_CFG_'

# Fix for issue #77, PR #78: https://github.com/confluentinc/kafka-rest/pull/78/files
sed -i 's/\"kafka\"//' /usr/bin/kafka-rest-run-class

eval $WAIT_FOR
exec /usr/bin/kafka-rest-start ${RP_CFG_FILE}
