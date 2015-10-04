Confluent Stream Data Platform on Docker
========================================

Experimental docker images for running the
[Confluent Platform](http://confluent.io/docs/current/index.html).
These images are currently intended for development use, not for production use.

The Docker version of the [Confluent Quickstart](http://confluent.io/docs/current/quickstart.html)
looks like this:

    # Start Zookeeper and expose port 2181 for use by the host machine
    docker run -d --name zookeeper -p 2181:2181 confluent/zookeeper

    # Start Kafka and expose port 9092 for use by the host machine
    docker run -d --name kafka -p 9092:9092 --link zookeeper:zookeeper confluent/kafka

    # Start Schema Registry and expose port 8081 for use by the host machine
    docker run -d --name schema-registry -p 8081:8081 --link zookeeper:zookeeper \
        --link kafka:kafka confluent/schema-registry

    # Start REST Proxy and expose port 8082 for use by the host machine
    docker run -d --name rest-proxy -p 8082:8082 --link zookeeper:zookeeper \
        --link kafka:kafka --link schema-registry:schema-registry confluent/rest-proxy

If you're using `boot2docker`, you'll need to adjust how you run Kafka:

    # Get the IP address of the docker machine
    DOCKER_MACHINE=`boot2docker ip`

    # Start Kafka and expose port 9092 for use by the host machine
    # Also configure the broker to use the docker machine's IP address
    docker run -d --name kafka -p 9092:9092 --link zookeeper:zookeeper \
        --env KAFKA_ADVERTISED_HOST_NAME=$DOCKER_MACHINE confluent/kafka

If all goes well when you run the quickstart, `docker ps` should give you something that looks like this:

    CONTAINER ID        IMAGE                              COMMAND                  CREATED             STATUS              PORTS                    NAMES
    7fc453ca701c        confluent/rest-proxy               "/usr/local/bin/rest-"   2 minutes ago       Up 2 minutes        0.0.0.0:8082->8082/tcp   rest-proxy
    4d33d52a98bd        confluent/schema-registry:latest   "/usr/local/bin/schem"   2 minutes ago       Up 2 minutes        0.0.0.0:8081->8081/tcp   schema-registry     
    d9613d3bc37d        confluent/kafka:latest             "/usr/local/bin/kafka"   2 minutes ago       Up 2 minutes        0.0.0.0:9092->9092/tcp   kafka               
    459afcb7dfcf        confluent/zookeeper:latest         "/usr/local/bin/zk-do"   2 minutes ago       Up 2 minutes        0.0.0.0:2181->2181/tcp   zookeeper           


## Running on Multiple Remote Hosts and Clustering
To run across multiple hosts you will need some way of communicating between Docker hosts so all remote containers can see each other. This is typically done via some sort of service discovery mechanism (so containers/services can find each other) and/or SDN (so containers can communicate) such as [weave](http://weave.works/) or [flannel](https://github.com/coreos/flannel) as SDN examples. Having that in place, you can use environment variables to specify the IP/hostname and respective ports for the remote containers and forgo the use of `--link`. For example to make a 3-node Zookeeper ensemble, each running on separate Docker hosts (zk-1:172.16.42.101, zk-2:172.16.42.102, and zk-3:172.16.42.103), and have a remote Kafka 2-node cluster connection:

```sh
docker run --name zk-1 -e zk_id=1 -e zk_server.1=172.16.42.101:2888:3888 -e zk_server.2=172.16.42.102:2888:3888 -e zk_server.3=172.16.42.103:2888:3888 -p 2181:2181 -p 2888:2888 -p 3888:3888 confluent/zookeeper
docker run --name zk-2 -e zk_id=2 -e zk_server.1=172.16.42.101:2888:3888 -e zk_server.2=172.16.42.102:2888:3888 -e zk_server.3=172.16.42.103:2888:3888 -p 2181:2181 -p 2888:2888 -p 3888:3888 confluent/zookeeper
docker run --name zk-3 -e zk_id=3 -e zk_server.1=172.16.42.101:2888:3888 -e zk_server.2=172.16.42.102:2888:3888 -e zk_server.3=172.16.42.103:2888:3888 -p 2181:2181 -p 2888:2888 -p 3888:3888 confluent/zookeeper
docker run --name kafka-1 -e KAFKA_BROKER_ID=1 -e KAFKA_ZOOKEEPER_CONNECT=172.16.42.101:2181,172.16.42.102:2181,172.16.42.103:2181 -p 9092:9092 confluent/kafka
docker run --name kafka-2 -e KAFKA_BROKER_ID=2 -e KAFKA_ZOOKEEPER_CONNECT=172.16.42.101:2181,172.16.42.102:2181,172.16.42.103:2181 -p 9092:9092 confluent/kafka
```

## Changing settings
The images support using environment variables via the Docker `-e | --env` flags for setting various settings in the respective images. For example:

  - For the Zookeeper image use variables prefixed with `ZOOKEEPER_` with the variables expressed exactly as how they would appear in the `zookeeper.properties` file. As an example, to set `syncLimit` and `server.1` you'd run `docker run --name zk -e ZOOKEEPER_syncLimit=2 -e ZOOKEEPER__server.1=localhost:2888:3888 confluent/zookeeper`.

  - For the Kafka image use variables prefixed with `KAFKA_` with an underscore (`_`) separating each word instead of periods. As an example, to set `broker.id` and `offsets.storage` you'd run `docker run --name kafka --link zookeeper:zookeeper -e KAFKA_BROKER_ID=2 -e KAFKA_OFFSETS_STORAGE=kafka confluent/kafka`.

  - For the Schema Registry image use variables prefixed with `SCHEMA_REGISTRY_` with an underscore (`_`) separating each word instead of periods. As an example, to set `kafkastore.topic` and `debug` you'd run `docker run --name schema-registry --link zookeeper:zookeeer --link kafka:kafka -e SCHEMA_REGISTRY_KAFKASTORE_TOPIC=_schemas -e SCHEMA_REGISTRY_DEBUG=true confluent/schema-registry`.

  - For the Kafka REST Proxy image use variables prefixed with `REST_PROXY_` with an underscore (`_`) separating each word instead of periods. As an example, to set `id` and `zookeeper_connect` you'd run `docker run --name rest-proxy --link schema-registry:schema-registry --link zookeeper:zookeeer -e REST_PROXY_ID=2 -e REST_PROXY_ZOOKEEPER_CONNECT=192.168.1.101:2182 confluent/rest-proxy`.

You can also download your own file, with similar variable substitution as shown above. To download your own file use the prefixes as shown above, with the special variable `CFG_URL` appended. For example, to download your own ZK configuration file and leverage the `ZOOKEEPER_` variable substitution you could do `docker run --name zk -e ZOOKEEPER_CFG_URL=http://myurl/zookeeper.properties ZOOKEEPER_id=1 -e ZOOKEEPER_maxClientCnxns=20 confluent/zookeeper`.


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

A second script, `push.sh`, will push the generated images to Docker
Hub. First you'll need to be logged in:

    docker login --username=yourhubusername --password=yourpassword --email=youremail@company.com

then execute the script.
