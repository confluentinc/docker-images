#!/bin/bash

# For commonly used command-line tools, this entrypoint script adds the
# necessary parameters to point them at the linked containers.

if [ "$1" = 'kafka-avro-console-consumer' ]; then
    shift
    exec /usr/bin/kafka-avro-console-consumer \
        --zookeeper ${ZOOKEEPER_PORT_2181_TCP_ADDR}:${ZOOKEEPER_PORT_2181_TCP_PORT} \
        --property schema.registry.url=http://${SCHEMA_REGISTRY_PORT_8081_TCP_ADDR}:${SCHEMA_REGISTRY_PORT_8081_TCP_PORT} \
        "$@"
fi

if [ "$1" = 'kafka-avro-console-producer' ]; then
    shift
    exec /usr/bin/kafka-avro-console-producer \
        --broker-list ${KAFKA_PORT_9092_TCP_ADDR}:${KAFKA_PORT_9092_TCP_PORT} \
        --property schema.registry.url=http://${SCHEMA_REGISTRY_PORT_8081_TCP_ADDR}:${SCHEMA_REGISTRY_PORT_8081_TCP_PORT} \
        "$@"
fi

exec "$@"
