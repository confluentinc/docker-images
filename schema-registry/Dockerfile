# Builds a docker image for the Confluent schema registry.
# Expects links to "kafka" and "zookeeper" containers.
#
# Usage:
#   docker build -t confluent/schema-registry schema-registry
#   docker run -d --name schema-registry --link zookeeper:zookeeper --link kafka:kafka \
#       --env SCHEMA_REGISTRY_AVRO_COMPATIBILITY_LEVEL=none confluent/schema-registry

FROM confluent/platform

RUN groupadd -r confluent && \
    useradd -r -g confluent confluent && \
    chown -R confluent:confluent /etc/schema-registry/schema-registry.properties

EXPOSE 8081
COPY schema-registry-docker.sh /
CMD /schema-registry-docker.sh
