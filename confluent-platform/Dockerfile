FROM ubuntu:15.10

ENV DEBIAN_FRONTEND noninteractive
ENV SCALA_VERSION="2.11.7"
ENV JAVA_VERSION="8"
ENV CONFLUENT_MAJOR_VERSION="2.0"

RUN apt-get update && \
    apt-get upgrade -y && \
	apt-get install -y curl openjdk-${JAVA_VERSION}-jre && \
    apt-get install -y build-essential scala software-properties-common wget && \
    wget -qO - http://packages.confluent.io/deb/2.0/archive.key | apt-key add - && \
    add-apt-repository "deb http://packages.confluent.io/deb/2.0 stable main" && \
    apt-get update && \
    apt-get install -y confluent-platform-${SCALA_VERSION}     
