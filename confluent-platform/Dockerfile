# Builds a base docker image for the Confluent stream platform. It doesn't
# start up any particular service, just installs the platform. Other images
# inherit from this image to start up a particular service.

FROM java:8-jre

ENV CONFLUENT_USER confluent
ENV CONFLUENT_GROUP confluent

RUN ["groupadd", "-r", "confluent"]
RUN ["useradd", "-r", "-g", "confluent", "confluent"]



