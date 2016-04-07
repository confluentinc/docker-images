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

ADD kafka-docker.sh /usr/local/bin/

RUN ["mkdir", "-p", "/var/lib/kafka", "/var/log/kafka", "/etc/security"]
RUN ["chown", "-R", "confluent:confluent", "/var/lib/kafka", "/var/log/kafka", "/etc/kafka/server.properties"]
RUN ["chmod", "+x", "/usr/local/bin/kafka-docker.sh"]

VOLUME ["/var/lib/kafka", "/var/log/kafka", "/etc/security"]

#TODO Update the ports that are exposed.
#TODO Add support to expose JMX
EXPOSE 9092

USER confluent
ENTRYPOINT ["/usr/local/bin/kafka-docker.sh"]
