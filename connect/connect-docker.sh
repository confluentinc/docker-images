#!/bin/bash

CONNECT_CFG_FILE="/etc/kafka/connect-distributed.properties"

# Force the log path into container volume 
#	NOTE: make sure this is writable (see Dockerfile)
export LOG_DIR='/var/log/kafka'

# Download the config file, if given a URL
if [ -n "$CONNECT_CFG_URL" ]; then
  echo "[CONNECT] Downloading CONNECT config file from ${CONNECT_CFG_URL}"
  curl --location --silent --insecure --output ${CONNECT_CFG_FILE} ${CONNECT_CFG_URL}
  if [ $? -ne 0 ]; then
    echo "[CONNECT] Failed to download ${CONNECT_CFG_URL} exiting."
    exit 1
  fi
fi

/usr/bin/docker-edit-properties --file ${CONNECT_CFG_FILE} --include 'CONNECT_(.*)' --include 'CONNECT_(.*)' --exclude '^CONNECT_CFG_'

# The standard Java properties class will "escape" colons in the file,
# which causes problems whenever we override values. 
# KLUDGE a fix here (assumming there will never be "\" in our properties file)
#
sed -i "s|\\\\||g" ${CC_CFG_FILE}

# HACK This is a total hack to get around launching several 
# containers at once. This give zookeeper and kafka time to start.
#
#	NOTE: The correct answer should be to wait until we see
#	broker ids in zookeeper; then it's safe to start.
#		sleep 10

echo $CONNECT_CFG_FILE
echo "-----------"
cat $CONNECT_CFG_FILE
echo ""

cat $CONNECT_CFG_FILE

exec /usr/bin/connect-distributed ${CONNECT_CFG_FILE}
