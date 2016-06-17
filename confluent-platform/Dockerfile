# Builds a base docker image for the Confluent stream platform. It doesn't
# start up any particular service, just installs the platform. Other images
# inherit from this image to start up a particular service.

FROM java:8-jre

ENV CONFLUENT_USER confluent
ENV CONFLUENT_GROUP confluent
ENV DOCKERIZE_VERSION v0.2.0
ENV DOCKERIZE_URL https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN ["groupadd", "-r", "confluent"]
RUN ["useradd", "-r", "-g", "confluent", "confluent"]

RUN wget -O /tmp/dockerize.tar.gz ${DOCKERIZE_URL}
RUN tar -C /usr/local/bin -xzvf /tmp/dockerize.tar.gz
RUN rm -rf /tmp/dockerize.tar.gz
