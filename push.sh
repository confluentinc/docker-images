#!/bin/bash

. settings.sh

for SCALA_VERSION in ${SCALA_VERSIONS}; do
    docker push confluent/platform-${SCALA_VERSION}
done
docker push confluent/platform

docker push confluent/zookeeper
docker push confluent/kafka
docker push confluent/schema-registry
docker push confluent/rest-proxy
docker push confluent/tools
