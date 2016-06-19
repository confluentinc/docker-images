#!/bin/bash

CC_CFG_FILE="/etc/confluent-control-center/control-center.properties"

# Download the config file, if given a URL
if [ -n "$CC_CFG_URL" ]; then
  echo "[CC] Downloading CC config file from ${CC_CFG_URL}"
  curl --location --silent --insecure --output ${CC_CFG_FILE} ${CC_CFG_URL}
  if [ $? -ne 0 ]; then
    echo "[CC] Failed to download ${CC_CFG_URL} exiting."
    exit 1
  fi
fi

/usr/bin/docker-edit-properties --file ${CC_CFG_FILE} --include 'CONTROL_CENTER_(.*)' --include 'CC_(.*)' --exclude '^CC_CFG_'

# The standard Java properties class will "escape" colons in the file,
# which causes problems whenever we override values. 
# KLUDGE a fix here (assumming there will never be "\" in our properties file)
#
sed -i "s|\\\\||g" ${CC_CFG_FILE}

# 
# HACK This is a total hack to get around launching several 
# containers at once. This give zookeeper and kafka time to start.
#
#	NOTE: The correct answer should be to wait until we see
#	broker ids in zookeeper; then it's safe to start.
#		sleep 10

echo $CC_CFG_FILE
echo "-----------"
cat $CC_CFG_FILE
echo ""

ping  -c 5 -W 200  worker

exec /usr/bin/control-center-start ${CC_CFG_FILE}
