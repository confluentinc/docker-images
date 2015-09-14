# Builds a base docker image for the Confluent stream platform. It doesn't
# start up any particular service, just installs the platform. Other images
# inherit from this image to start up a particular service.

FROM debian:wheezy

ENV SCALA_VERSION="2.10.4"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl openjdk-7-jre-headless && \
    curl -SL http://packages.confluent.io/deb/1.0/archive.key | apt-key add - && \
    echo 'deb [arch=all] http://packages.confluent.io/deb/1.0 stable main' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y confluent-platform-${SCALA_VERSION}
