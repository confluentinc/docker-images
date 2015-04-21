# Builds a docker image running Apache Zookeeper. Intended for use with Kafka.
#
# Usage:
#   docker build -t confluent/zookeeper:1.0-test1 zookeeper
#   docker run -d --name zookeeper confluent/zookeeper:1.0-test1

FROM confluent/platform:1.0-test1

# Send all logs to stdout (so that they are shown by `docker logs`)
RUN rm /etc/kafka/log4j.properties && \
    echo 'log4j.rootLogger=INFO, stdout' >> /etc/kafka/log4j.properties && \
    echo 'log4j.appender.stdout=org.apache.log4j.ConsoleAppender' >> /etc/kafka/log4j.properties && \
    echo 'log4j.appender.stdout.layout=org.apache.log4j.PatternLayout' >> /etc/kafka/log4j.properties && \
    echo 'log4j.appender.stdout.layout.ConversionPattern=[%d] %p %m (%c)%n' >> /etc/kafka/log4j.properties

RUN groupadd -r confluent && \
    useradd -r -g confluent confluent && \
    mkdir /var/lib/zookeeper && \
    chown -R confluent:confluent /var/lib/zookeeper

USER confluent
VOLUME /var/lib/zookeeper
EXPOSE 2181

ENV KAFKA_LOG4J_OPTS -Dlog4j.configuration=file:/etc/kafka/log4j.properties
CMD /usr/bin/zookeeper-server-start /etc/kafka/zookeeper.properties
