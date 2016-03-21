# Builds a docker image running Confluent's distribution of Apache Kafka.
# Needs to be linked with a Zookeeper container with alias "zookeeper".
#
# Usage:
#   docker build -t confluent/kafka kafka
#   docker run -d --name kafka --link zookeeper:zookeeper confluent/kafka

FROM confluent/platform

ENV CONFLUENT_USER confluent
ENV CONFLUENT_GROUP confluent
ENV KAFKA_LOGS "/var/log/kafka"
ENV KAFKA_LOG_DIRS "/var/lib/kafka"

COPY kafka-docker.sh /usr/local/bin/

RUN groupadd -r ${CONFLUENT_GROUP} &&\
    useradd -r -g ${CONFLUENT_GROUP} ${CONFLUENT_USER} &&\
    mkdir -p ${KAFKA_LOG_DIRS} ${KAFKA_LOGS} &&\
    chown -R ${CONFLUENT_USER}:${CONFLUENT_GROUP} ${KAFKA_LOG_DIRS} ${KAFKA_LOGS} /etc/kafka/server.properties /usr/local/bin/kafka-docker.sh &&\
    chmod +x /usr/local/bin/kafka-docker.sh


USER ${CONFLUENT_USER}
VOLUME ["${KAFKA_LOG_DIRS}", "${KAFKA_LOGS}"]
EXPOSE 9092

ENTRYPOINT ["/usr/local/bin/kafka-docker.sh"]
