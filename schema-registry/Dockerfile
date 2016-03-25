# Builds a docker image for the Confluent schema registry.
# Expects links to "kafka" and "zookeeper" containers.
#
# Usage:
#   docker build -t confluent/schema-registry schema-registry
#   docker run -d --name schema-registry --link zookeeper:zookeeper --link kafka:kafka \
#       --env SCHEMA_REGISTRY_AVRO_COMPATIBILITY_LEVEL=none confluent/schema-registry

FROM confluent/platform

MAINTAINER contact@confluent.io

COPY schema-registry-docker.sh /usr/local/bin/

RUN ["chown", "-R", "${CONFLUENT_USER}:${CONFLUENT_GROUP}", "/etc/schema-registry/schema-registry.properties", "/usr/local/bin/schema-registry-docker.sh"]
RUN ["chmod", "+x", "/usr/local/bin/schema-registry-docker.sh"]

EXPOSE 8081

ENTRYPOINT ["/usr/local/bin/schema-registry-docker.sh"]
