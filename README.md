Confluent Stream Data Platform on Docker
========================================

Experimental docker images for running the
[Confluent Platform](http://confluent.io/docs/current/index.html).
These images are currently intended for development use, not for production use.

The Docker version of the [Confluent Quickstart](http://confluent.io/docs/current/quickstart.html)
looks like this:

    # Start Zookeeper
    docker run -d --name zookeeper confluent/zookeeper:1.0-test1

    # Start Kafka
    docker run -d --name kafka --link zookeeper:zookeeper confluent/kafka:1.0-test1

    # Start Schema Registry
    docker run -d --name schema-registry --link zookeeper:zookeeper \
        --link kafka:kafka confluent/schema-registry:1.0-test1
