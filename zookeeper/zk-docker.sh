#!/bin/bash

ZK_CFG_FILE="/etc/kafka/zookeeper.properties"

: ${zk_id:=1}
: ${zk_tickTime:=2000}
: ${zk_initLimit:=5}
: ${zk_syncLimit:=2}
: ${zk_clientPort:=2181}
: ${zk_maxClientCnxns:=0}

export zk_dataDir='/var/lib/zookeeper'

export zk_id
export zk_tickTime
export zk_initLimit
export zk_syncLimit
export zk_clientPort
export zk_maxClientCnxns

# Download the config file, if given a URL
if [ ! -z "$ZK_CFG_URL" ]; then
  echo "[zk] Downloading zk config file from ${ZK_CFG_URL}"
  curl --location --silent --insecure --output ${ZK_CFG_FILE} ${ZK_CFG_URL}
  if [ $? -ne 0 ]; then
    echo "[zk] Failed to download ${ZK_CFG_URL} exiting."
    exit 1
  fi
fi

# Set Zookeeper ID
echo $zk_id > $zk_dataDir/myid

/usr/bin/docker-edit-properties --preserve-case --file ${ZK_CFG_FILE} --include 'ZK_(.*)' --include 'zk_(.*)' --exclude '^zk_cfg_'

exec /usr/bin/zookeeper-server-start ${ZK_CFG_FILE}
