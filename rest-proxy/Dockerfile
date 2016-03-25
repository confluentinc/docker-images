# Builds a docker image for the Kafka REST Proxy.
# Expects links to "schema-registry" and "zookeeper" containers.
#
# Usage:
#   docker build -t confluent/rest-proxy rest-proxy
#   docker run -d --name rest-proxy --link zookeeper:zookeeper --link schema-registry:schema-registry \
#       confluent/rest-proxy

FROM confluent/platform

MAINTAINER contact@confluent.io

COPY rest-proxy-docker.sh /usr/local/bin/

RUN ["chown", "-R", "confluent:confluent", "/etc/kafka-rest", "/usr/local/bin/rest-proxy-docker.sh"]
RUN ["chmod", "+x", "/usr/local/bin/rest-proxy-docker.sh"]

EXPOSE 8082

CMD [ "/usr/local/bin/rest-proxy-docker.sh" ]
