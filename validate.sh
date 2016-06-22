#!/usr/bin/env bash

# This script should run after you:
#
# Started the confluent stack containers:
# cd examples/fullstack
# docker-compose up
#
# Added the docker host to the hosts file:
# echo `docker-machine ip confluent` confluent | sudo tee -a /etc/hosts > /dev/null
#
# Now we are ready to validate!

. settings.sh

TEXT_TOPIC="validate.t1"
AVRO_TOPIC="validate.avro1"

# Change HOSTs and NET to desired config
# If using docker-compose you will need to associate each docker host  to it's host
# name or IP within the created network (usually zookeer, kafka, and schema-registry).
# ZK_HOST is your localhost usually if zookeeper has exposed ports from the container
# if running in docker-compose.
: ${DOCKER_ZK_HOST:="confluent"}
: ${DOCKER_KF_HOST:="confluent"}
: ${DOCKER_SR_HOST:="confluent"}
: ${ZK_HOST:="confluent"}
: ${NET:="host"}

echo -e "cleaning up existing validation topics $TEXT_TOPIC and $AVRO_TOPIC\n"
docker run --rm --interactive --net=${NET} "confluent/tools:${KAFKA_VERSION}" kafka-topics --zookeeper ${DOCKER_ZK_HOST}:2181 --delete --topic ${TEXT_TOPIC}
docker run --rm --interactive --net=${NET} "confluent/tools:${KAFKA_VERSION}" kafka-topics --zookeeper ${DOCKER_ZK_HOST}:2181 --delete --topic ${AVRO_TOPIC}
docker run --rm --interactive --net=${NET} "confluent/tools:${KAFKA_VERSION}" kafka-topics --zookeeper ${DOCKER_ZK_HOST}:2181 --create --topic ${TEXT_TOPIC} --partitions 1 --replication-factor 1
docker run --rm --interactive --net=${NET} "confluent/tools:${KAFKA_VERSION}" kafka-topics --zookeeper ${DOCKER_ZK_HOST}:2181 --create --topic ${AVRO_TOPIC} --partitions 1 --replication-factor 1
sleep 10

echo -e "producing a message\n"
echo "hello docker" | docker run --rm --interactive --net=${NET} "confluent/tools:${KAFKA_VERSION}" kafka-console-producer --broker-list ${DOCKER_KF_HOST}:9092 --topic ${TEXT_TOPIC}

echo -e "consuming a message\n"
(docker run --rm --interactive --net=${NET} "confluent/tools:${KAFKA_VERSION}" kafka-console-consumer --new-consumer --bootstrap-server ${DOCKER_KF_HOST}:9092 --from-beginning --topic  ${TEXT_TOPIC}) & sleep 5; kill $!

echo -e "Getting information about our topic from the rest proxy\n"
curl "http://${ZK_HOST}:8082/topics/${TEXT_TOPIC}"

echo -e "\nProducing an Avro message via the rest proxy\n"
 curl -X POST -H "Content-Type: application/vnd.kafka.avro.v1+json" \
      --data '{"value_schema": "{\"type\": \"record\", \"name\": \"User\", \"fields\": [{\"name\": \"name\", \"type\": \"string\"}]}", "records": [{"value": {"name": "testUser"}}]}' \
      "http://${ZK_HOST}:8082/topics/${AVRO_TOPIC}"

echo -e "\nConsuming an Avro message, via the avro console consumer\n"
(docker run --rm --interactive --net=${NET} "confluent/tools:${KAFKA_VERSION}" kafka-avro-console-consumer --new-consumer --bootstrap-server ${DOCKER_KF_HOST}:9092 --from-beginning --topic  ${AVRO_TOPIC} --property schema.registry.url=http://${DOCKER_SR_HOST}:8081) & sleep 5; kill $!
