# Builds a docker image for the Kafka REST Proxy.
# Expects links to "schema-registry" and "zookeeper" containers.
#
# Usage:
#   docker build -t confluent/rest-proxy rest-proxy
#   docker run -d --name rest-proxy --link zookeeper:zookeeper --link schema-registry:schema-registry \
#       confluent/rest-proxy

FROM confluent/platform

ENV CONFLUENT_USER confluent
ENV CONFLUENT_GROUP confluent

COPY rest-proxy-docker.sh /usr/local/bin/

RUN groupadd -r ${CONFLUENT_GROUP} &&\
    useradd -r -g ${CONFLUENT_GROUP} ${CONFLUENT_USER} &&\
    chown -R ${CONFLUENT_USER}:${CONFLUENT_GROUP} /etc/kafka-rest /usr/local/bin/rest-proxy-docker.sh &&\
    chmod +x /usr/local/bin/rest-proxy-docker.sh

USER ${CONFLUENT_USER}

EXPOSE 8082

CMD [ "/usr/local/bin/rest-proxy-docker.sh" ]
