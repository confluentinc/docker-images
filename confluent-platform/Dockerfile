# Builds a base docker image for the Confluent stream platform. It doesn't
# start up any particular service, just installs the platform. Other images
# inherit from this image to start up a particular service.

FROM ubuntu:15.10

ENV DEBIAN_FRONTEND noninteractive
ENV SCALA_VERSION="2.11.7"
ENV JAVA_VERSION="8"
ENV CONFLUENT_MAJOR_VERSION="2.0"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential scala software-properties-common wget && \
    wget -qO - http://packages.confluent.io/deb/2.0/archive.key | apt-key add - && \
    add-apt-repository "deb http://packages.confluent.io/deb/2.0 stable main" && \
    apt-get update && \
    apt-get install -y confluent-platform-${SCALA_VERSION} && \
    apt-add-repository -y ppa:webupd8team/java && \
    apt-get update && \
    echo oracle-java-8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer oracle-java8-set-default
