# Builds a docker image running Apache Zookeeper. Intended for use with Kafka.
#
# Usage:
#   docker build -t confluent/zookeeper zookeeper
#   docker run -d --name zookeeper confluent/zookeeper

FROM confluent/platform

ENV ZK_DATA_DIR "/var/lib/zookeeper"
ENV CONFLUENT_USER confluent
ENV CONFLUENT_GROUP confluent
ENV KAFKA_LOG4J_OPTS -Dlog4j.configuration=file:/etc/kafka/log4j.properties

COPY zk-docker.sh /usr/local/bin/

# Send all logs to stdout (so that they are shown by `docker logs`)
RUN rm /etc/kafka/log4j.properties &&\
    echo 'log4j.rootLogger=INFO, stdout' >> /etc/kafka/log4j.properties &&\
    echo 'log4j.appender.stdout=org.apache.log4j.ConsoleAppender' >> /etc/kafka/log4j.properties &&\
    echo 'log4j.appender.stdout.layout=org.apache.log4j.PatternLayout' >> /etc/kafka/log4j.properties &&\
    echo 'log4j.appender.stdout.layout.ConversionPattern=[%d] %p %m (%c)%n' >> /etc/kafka/log4j.properties &&\
    groupadd -r ${CONFLUENT_GROUP} &&\
    useradd -r -g ${CONFLUENT_GROUP} ${CONFLUENT_USER} &&\
    mkdir ${ZK_DATA_DIR} &&\
    chown -R ${CONFLUENT_GROUP}:${CONFLUENT_USER} ${ZK_DATA_DIR} /usr/local/bin/zk-docker.sh /etc/kafka/zookeeper.properties &&\
    chmod +x /usr/local/bin/zk-docker.sh

USER ${CONFLUENT_USER}
VOLUME ["${ZK_DATA_DIR}"]

# Expose client port (2188/tcp), peer connection port (2888/tcp), leader election port (3888/tcp)
EXPOSE 2181 2888 3888

ENTRYPOINT ["/usr/local/bin/zk-docker.sh"]
CMD [""]
