# Builds a docker image with command-line tools for the Confluent platform.
# Expects links to "kafka" and "zk" containers.
#
# Usage:
#   docker build -t confluent/tools tools
#   docker run -it --rm --link zookeeper:zookeeper --link kafka:kafka --link schema-registry:schema_registry \
#       confluent/tools kafka-avro-console-consumer --property print.key=true --topic test --from-beginning

FROM confluent/platform

MAINTAINER contact@confluent.io

WORKDIR /usr/bin

ADD confluent-tools.sh /usr/bin/confluent-tools
CMD ["confluent-tools"]
