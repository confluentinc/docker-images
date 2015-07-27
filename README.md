Confluent Stream Data Platform on Docker
========================================

Experimental docker images for running the
[Confluent Platform](http://confluent.io/docs/current/index.html).
These images are currently intended for development use, not for production use.

The Docker version of the [Confluent Quickstart](http://confluent.io/docs/current/quickstart.html)
looks like this:

    # Get the IP address of the docker machine
    DOCKER_MACHINE=`boot2docker ip`

    # Start Zookeeper and expose port 2181 for use by the host machine
    docker run -d --name zookeeper -p 2181:2181 confluent/zookeeper

    # Start Kafka and expose port 9092 for use by the host machine
    # Also configure the broker to use the docker machine's IP address
    docker run -d --name kafka -p 9092:9092 --link zookeeper:zookeeper \
        --env KAFKA_ADVERTISED_HOST_NAME=$DOCKER_MACHINE confluent/kafka

    # Start Schema Registry and expose port 8081 for use by the host machine
    docker run -d --name schema-registry -p 8081:8081 --link zookeeper:zookeeper \
        --link kafka:kafka confluent/schema-registry

If all goes well when you run the quickstart, `docker ps` should give you something that looks like this:

    CONTAINER ID        IMAGE                              COMMAND                CREATED             STATUS              PORTS                    NAMES
    4d33d52a98bd        confluent/schema-registry:latest   "/bin/sh -c /schema-   10 minutes ago      Up 10 minutes       0.0.0.0:8081->8081/tcp   schema-registry     
    d9613d3bc37d        confluent/kafka:latest             "/bin/sh -c /kafka-d   10 minutes ago      Up 10 minutes       0.0.0.0:9092->9092/tcp   kafka               
    459afcb7dfcf        confluent/zookeeper:latest         "/bin/sh -c '/usr/bi   10 minutes ago      Up 10 minutes       0.0.0.0:2181->2181/tcp   zookeeper           


