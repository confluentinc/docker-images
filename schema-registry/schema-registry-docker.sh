#!/bin/bash

SR_CFG_FILE="/etc/schema-registry/schema-registry.properties"

# Download the config file, if given a URL
if [ ! -z "$SR_CFG_URL" ]; then
  echo "[SR] Downloading SR config file from ${SR_CFG_URL}"
  curl --location --silent --insecure --output ${SR_CFG_FILE} ${SR_CFG_URL}
  if [ $? -ne 0 ]; then
    echo "[SR] Failed to download ${SR_CFG_URL} exiting."
    exit 1
  fi
fi

/usr/bin/docker-edit-properties --file ${SR_CFG_FILE} --include 'SR_(.*)' --include 'SCHEMA_REGISTRY_(.*)' --exclude '^SR_CFG_FILE'

exec /usr/bin/schema-registry-start ${SR_CFG_FILE}
