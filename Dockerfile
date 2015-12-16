# Builds a base docker image for the Confluent stream platform. It doesn't
# start up any particular service, just installs the platform. Other images
# inherit from this image to start up a particular service.

FROM debian:8.2

ENV JAVA_VERSION="7"

# This stuff should not need updating too frequently so lets give it
# it's own layer
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common && \
    apt-get install -y curl openjdk-${JAVA_VERSION}-jre-headless && \
    apt-get install -y supervisor


# Confluent
ENV SCALA_VERSION="2.10.5"
ENV CONFLUENT_MAJOR_VERSION="2.0"
RUN curl -SL http://packages.confluent.io/deb/${CONFLUENT_MAJOR_VERSION}/archive.key | apt-key add - && \
    apt-add-repository "deb http://packages.confluent.io/deb/2.0 stable main" && \
    apt-get update && \
    apt-get install -y confluent-platform-${SCALA_VERSION}

COPY etc /etc

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

EXPOSE 2181 9092 8081 8082
