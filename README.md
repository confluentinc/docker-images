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

    # Start Schema Registry
    docker run -d --name schema-registry --link zookeeper:zookeeper \
        --link kafka:kafka confluent/schema-registry


## Running on Multiple Remote Hosts and Clustering
To run across multiple hosts you will need some way of communicating between Docker hosts so all remote containers can see each other. This is typically done via some sort of service discovery mechanism (so containers/services can find each other) and/or SDN (so containers can communicate) such as [weave](http://weave.works/) or [flannel](https://github.com/coreos/flannel) as SDN examples. Having that in place, you can use environment variables to specify the IP/hostname and respective ports for the remote containers and forgo the use of `--link`. For example to make a 3-node Zookeeper ensemble, each running on separate Docker hosts (zk-1:172.16.42.101, zk-2:172.16.42.102, and zk-3:172.16.42.103), and have a remote Kafka 2-node cluster connection:

```sh
docker run --name zk-1 -e zk_id=1 -e zk_server.1=172.16.42.101:2888:3888 -e zk_server.2=172.16.42.102:2888:3888 -e zk_server.2=172.16.42.103:2888:3888 -p 2181:2181 -p 2888:2888 -p 3888:3888 confluent/zookeeper
docker run --name zk-2 -e zk_id=2 -e zk_server.1=172.16.42.101:2888:3888 -e zk_server.2=172.16.42.102:2888:3888 -e zk_server.2=172.16.42.103:2888:3888 -p 2181:2181 -p 2888:2888 -p 3888:3888 confluent/zookeeper
docker run --name zk-3 -e zk_id=3 -e zk_server.1=172.16.42.101:2888:3888 -e zk_server.2=172.16.42.102:2888:3888 -e zk_server.2=172.16.42.103:2888:3888 -p 2181:2181 -p 2888:2888 -p 3888:3888 confluent/zookeeper
docker run --name kafka-1 -e KAFKA_BROKER_ID=1 -e KAFKA_ZOOKEEPER_CONNECT=172.16.42.101:2181,172.16.42.102:2181,172.16.42.103:2181 -p 9092:9092 confluent/kafka
docker run --name kafka-2 -e KAFKA_BROKER_ID=2 -e KAFKA_ZOOKEEPER_CONNECT=172.16.42.101:2181,172.16.42.102:2181,172.16.42.103:2181 -p 9092:9092 confluent/kafka
```

## Changing settings
The images support using environment variables via the Docker `-e | --env` flags for setting various settings in the respective images. For example:

  - For the Zookeeper image use variables prefixed with `zk_` with the variables expressed exactly as how they would appear in the `zookeeper.properties` file. As an example, to set `syncLimit` and `server.1` you'd run `docker run --name zk -e zk_syncLimit=2 -e zk_server.1=localhost:2888:3888 confluent/zookeeper`.

  - For the Kafka image use variables prefixed with `KAFKA_` with an underscore (`_`) separating each word instead of periods. As an example, to set `broker.id` and `offsets.storage` you'd run `docker run --name kafka --link zookeeper:zk -e KAFKA_BROKER_ID=2 -e KAFKA_OFFSETS_STORAGE=kafka confluent/kafka`.

  - For the Schema Registry image use variables prefixed with `SR_` with an underscore (`_`) separating each word instead of periods. As an example, to set `kafkastore.topic` and `debug` you'd run `docker run --name schema-registry --link zookeeper:zk --link kafka:kafka -e SR_KAFKASTORE_TOPIC=_schemas -e SR_DEBUG=true confluent/schema-registry`.

  - For the Kafka REST Proxy image use variables prefixed with `RP_` with an underscore (`_`) separating each word instead of periods. As an example, to set `id` and `zookeeper_connect` you'd run `docker run --name rest-proxy --link sr:schema_registry --link zookeeper:zk -e RP_ID=2 -e RP_ZOOKEEPER_CONNECT=192.168.1.101:2182 confluent/rest-proxy`.

You can also download your own file, with similar variable substitution as shown above. To download your own file use the prefixes as shown above, with the special variable `CFG_URL` appended. For example, to download your own ZK configuration file and leverage the `zk_` variable substitution you could do `docker run --name zk -e zk_cfg_url=http://myurl/zookeeper.properties zk_id=1 -e zk_maxClientCnxns=20 confluent/zookeeper`.
