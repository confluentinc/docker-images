#!/bin/bash

# For commonly used command-line tools, this entrypoint script adds the
# necessary parameters to point them at the linked containers.

cat <<EOL

The following commands are available on this docker image. You can generate bash aliases using ${0} alias.

EOL



if [ "$1" = "alias" ]; then
    echo alias camus-config=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" camus-config\'
    echo alias camus-run=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" camus-run\'
    echo alias connect-distributed=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" connect-distributed\'
    echo alias connect-standalone=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" connect-standalone\'
    echo alias kafka-acls=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-acls\'
    echo alias kafka-avro-console-consumer=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-avro-console-consumer\'
    echo alias kafka-avro-console-producer=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-avro-console-producer\'
    echo alias kafka-configs=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-configs\'
    echo alias kafka-console-consumer=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-console-consumer\'
    echo alias kafka-console-producer=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-console-producer\'
    echo alias kafka-consumer-groups=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-consumer-groups\'
    echo alias kafka-consumer-offset-checker=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-consumer-offset-checker\'
    echo alias kafka-consumer-perf-test=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-consumer-perf-test\'
    echo alias kafka-mirror-maker=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-mirror-maker\'
    echo alias kafka-preferred-replica-election=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-preferred-replica-election\'
    echo alias kafka-producer-perf-test=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-producer-perf-test\'
    echo alias kafka-reassign-partitions=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-reassign-partitions\'
    echo alias kafka-replay-log-producer=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-replay-log-producer\'
    echo alias kafka-replica-verification=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-replica-verification\'
    echo alias kafka-rest-run-class=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-rest-run-class\'
    echo alias kafka-rest-start=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-rest-start\'
    echo alias kafka-rest-stop=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-rest-stop\'
    echo alias kafka-rest-stop-service=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-rest-stop-service\'
    echo alias kafka-run-class=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-run-class\'
    echo alias kafka-server-start=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-server-start\'
    echo alias kafka-server-stop=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-server-stop\'
    echo alias kafka-simple-consumer-shell=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-simple-consumer-shell\'
    echo alias kafka-topics=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-topics\'
    echo alias kafka-verifiable-consumer=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-verifiable-consumer\'
    echo alias kafka-verifiable-producer=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" kafka-verifiable-producer\'
    echo alias schema-registry-run-class=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" schema-registry-run-class\'
    echo alias schema-registry-start=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" schema-registry-start\'
    echo alias schema-registry-stop=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" schema-registry-stop\'
    echo alias schema-registry-stop-service=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" schema-registry-stop-service\'
    echo alias support-metrics-bundle=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" support-metrics-bundle\'
    echo alias zookeeper-security-migration=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" zookeeper-security-migration\'
    echo alias zookeeper-server-start=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" zookeeper-server-start\'
    echo alias zookeeper-server-stop=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" zookeeper-server-stop\'
    echo alias zookeeper-shell=\'docker run --rm --interactive --net=host "confluent/tools:2.0.1" zookeeper-shell\'
else
    echo camus-config
    echo camus-run
    echo connect-distributed
    echo connect-standalone
    echo kafka-acls
    echo kafka-avro-console-consumer
    echo kafka-avro-console-producer
    echo kafka-configs
    echo kafka-console-consumer
    echo kafka-console-producer
    echo kafka-consumer-groups
    echo kafka-consumer-offset-checker
    echo kafka-consumer-perf-test
    echo kafka-mirror-maker
    echo kafka-preferred-replica-election
    echo kafka-producer-perf-test
    echo kafka-reassign-partitions
    echo kafka-replay-log-producer
    echo kafka-replica-verification
    echo kafka-rest-run-class
    echo kafka-rest-start
    echo kafka-rest-stop
    echo kafka-rest-stop-service
    echo kafka-run-class
    echo kafka-server-start
    echo kafka-server-stop
    echo kafka-simple-consumer-shell
    echo kafka-topics
    echo kafka-verifiable-consumer
    echo kafka-verifiable-producer
    echo schema-registry-run-class
    echo schema-registry-start
    echo schema-registry-stop
    echo schema-registry-stop-service
    echo support-metrics-bundle
    echo zookeeper-security-migration
    echo zookeeper-server-start
    echo zookeeper-server-stop
    echo zookeeper-shell
fi
