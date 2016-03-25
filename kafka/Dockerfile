# Builds a docker image running Confluent's distribution of Apache Kafka.
# Needs to be linked with a Zookeeper container with alias "zookeeper".
#
# Usage:
#   docker build -t confluent/kafka kafka
#   docker run -d --name kafka --link zookeeper:zookeeper confluent/kafka

FROM confluent/platform

MAINTAINER contact@confluent.io

ENV LOG_DIR "/var/log/kafka"
ENV KAFKA_LOG_DIRS "/var/lib/kafka"

COPY kafka-docker.sh /usr/local/bin/

RUN ["mkdir", "-p", "${KAFKA_LOG_DIRS}", "${KAFKA_LOGS}"]
RUN ["chown", "-R", "${CONFLUENT_USER}:${CONFLUENT_GROUP}", "${KAFKA_LOG_DIRS}", "${KAFKA_LOGS}", "/etc/kafka/server.properties", "/usr/local/bin/kafka-docker.sh"]
RUN ["chmod", "+x", "/usr/local/bin/kafka-docker.sh"]

VOLUME ["${KAFKA_LOG_DIRS}", "${LOG_DIR}"]
EXPOSE 9092

ENTRYPOINT ["/usr/local/bin/kafka-docker.sh"]
