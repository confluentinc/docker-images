#!/bin/bash

# For commonly used command-line tools, this entrypoint script adds the
# necessary parameters to point them at the linked containers.

: ${TOOLS_ZK_CONNECTION_URL:=$ZOOKEEPER_PORT_2181_TCP_ADDR:$ZOOKEEPER_PORT_2181_TCP_PORT}
: ${TOOLS_KAFKA_CONNECTION_URL:=$KAFKA_PORT_9092_TCP_ADDR:$KAFKA_PORT_9092_TCP_PORT}
: ${TOOLS_SR_CONNECTION_URL:=$SCHEMA_REGISTRY_PORT_8081_TCP_ADDR:$SCHEMA_REGISTRY_PORT_8081_TCP_PORT}

export TOOLS_ZK_CONNECTION_URL
export TOOLS_KAFKA_CONNECTION_URL
export TOOLS_SR_CONNECTION_URL

if [ "$1" = 'kafka-avro-console-consumer' ]; then
    shift
    exec /usr/bin/kafka-avro-console-consumer \
        --zookeeper ${TOOLS_ZK_CONNECTION_URL} \
        --property schema.registry.url=http://${SCHEMA_REGISTRY_PORT_8081_TCP_ADDR}:${SCHEMA_REGISTRY_PORT_8081_TCP_PORT} \
        "$@"
fi

if [ "$1" = 'kafka-avro-console-producer' ]; then
    shift
    exec /usr/bin/kafka-avro-console-producer \
        --broker-list ${TOOLS_KAFKA_CONNECTION_URL} \
        --property schema.registry.url=http://${TOOLS_SR_CONNECTION_URL} \
        "$@"
fi

exec "$@"
