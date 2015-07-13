# Builds a base docker image for the Confluent stream platform. It doesn't
# start up any particular service, just installs the platform. Other images
# inherit from this image to start up a particular service.

FROM debian:8.1

ENV DEBIAN_FRONTEND noninteractive

ENV SCALA_VERSION="2.11.5"

ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 45
ENV JAVA_VERSION_BUILD 14
ENV JAVA_BASE /opt/java
ENV JAVA_HOME $JAVA_BASE/jre

RUN apt-get -y update &&\
    apt-get upgrade -y &&\
    apt-get install -y curl &&\
    mkdir ${JAVA_BASE} &&\
    curl --silent --insecure --location --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/server-jre-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz | tar zxf - -C $JAVA_BASE &&\
    update-alternatives --install /usr/bin/java java $JAVA_BASE/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}/bin/java 100 &&\
    update-alternatives --install /usr/bin/javac javac $JAVA_BASE/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}/bin/javac 100 &&\
    curl -SL http://packages.confluent.io/deb/1.0/archive.key | apt-key add - &&\
    echo 'deb [arch=all] http://packages.confluent.io/deb/1.0 stable main' >> /etc/apt/sources.list &&\
    apt-get -y update &&\
    apt-get install -y confluent-platform-${SCALA_VERSION}
