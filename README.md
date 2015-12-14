# CDDR's Confluent Stack
========================================

Experimental docker image for developing applications dependent on the
confluent stack.

Confluent publishes their own images but using combining them in a
docker-compose is problematic because all services are started at the
same time and the schema-registry for example typically aborts if kafka
has not yet come up by the time it tries to create the "_schemas" topic.

Here we start a supervisord process and run all the confluent apps under
that. We also redirect all their output to the supervisor so you can
see it by running "docker logs" on the container.

# Usage

```
git clone https://github.com/cddr/docker-images.git
make build
DEV_STACK=$(docker run -d cddr/dev-stack)
```

You now have the following services running on your docker host

 * zookeeper
 * kafka
 * schema-registry
 * rest-proxy

You can see the service logs `docker logs -f $DEV_STACK`
You can stop the services `docker stop $DEV_STACK`
You can restart the services in a group `docker restart $DEV_STACK`

You can use this image in a docker-compose.yml

```
appstack:
  environment:
    - KAFKA_ADVERTISED_HOST_NAME=192.168.99.103
  image: cddr/dev-stack
  ports:
    - "2181:2181"
    - "9092:9092"
    - "8081:8081"
    - "8082:8082"

app:
  links:
    - appstack
```
