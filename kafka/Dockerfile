# Builds a docker image running Confluent's distribution of Apache Kafka.
# Needs to be linked with a Zookeeper container with alias "zookeeper".
#
# Usage:
#   docker build -t confluent/kafka kafka
#   docker run -d --name kafka --link zookeeper:zookeeper confluent/kafka

FROM confluent/platform

RUN groupadd -r confluent && \
    useradd -r -g confluent confluent && \
    mkdir -p /var/lib/kafka /var/log/kafka && \
    chown -R confluent:confluent /var/lib/kafka /var/log/kafka /etc/kafka/server.properties

COPY kafka-docker.sh /

USER confluent
VOLUME ["/var/lib/kafka", "/var/log/kafka"]
EXPOSE 9092

CMD /kafka-docker.sh
