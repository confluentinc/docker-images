Confluent Stream Data Platform on Docker
========================================

Experimental docker images for running the
[Confluent Platform](http://confluent.io/docs/current/index.html).
These images are currently intended for development use, not for production use.

The Docker version of the [Confluent Quickstart](http://confluent.io/docs/current/quickstart.html)
looks like this:

    # Start Zookeeper
    docker run -d --name zookeeper confluent/zookeeper

    # Start Kafka
    docker run -d --name kafka --link zookeeper:zookeeper confluent/kafka

    # Start Schema Registry
    docker run -d --name schema-registry --link zookeeper:zookeeper \
        --link kafka:kafka confluent/schema-registry

    # Start REST Proxy
    docker run -d --name rest-proxy --link zookeeper:zookeeper \
        --link kafka:kafka --link schema-registry:schema-registry confluent/rest-proxy

Building Images
---------------

For convenience, a `build.sh` script is provided to build all variants of
images. This includes:

* `confluent-platform` - Confluent Platform base images, with all Confluent
  Platform packages installed. There are separate images for each Scala
  version. These images are tagged as `confluent/platform-$SCALA_VERSION`, with
  the default (2.10.4) also tagged as `confluent/platform`.
* `confluent/zookeeper` - starts Zookeeper on port 2181.
* `confluent/kafka` - starts Kafka on 9092.
* `confluent/schema-registry` - starts the Schema Registry on 8081.
* `confluent/rest-proxy` - starts the Kafka REST Proxy on 8082.
* `confluent-tools` - provides tools with a few links to other containers for
  commonly used tools.

Note that all services are built only using the *default Scala version*. When
run as services, the Scala version should not matter. If you need a specific
Scala version, use the corresponding `confluent/platform-$SCALA_VERSION` image
as your `FROM` line in your derived Dockerfile.
