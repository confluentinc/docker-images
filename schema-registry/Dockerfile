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

#TODO Schema Registry needs a log directory.
RUN ["chown", "-R", "confluent:confluent", "/etc/schema-registry/schema-registry.properties"]
RUN ["chmod", "+x", "/usr/local/bin/schema-registry-docker.sh"]

EXPOSE 8081

USER confluent
ENTRYPOINT ["/usr/local/bin/schema-registry-docker.sh"]
