# Builds a docker image for the Confluent Control Center.
# Expects links to 
#	"zookeeper" container
#	"broker" container (any of the running clusters .. though we could 
#		conceivably extract that from zookeeper
#
# Usage:
#   docker build -t confluent/control-center control-center
#   docker run -d --name control-center \
#		--link zookeeper:zookeeper --link broker:broker \ 
#       confluent/control-center

FROM confluent/platform

MAINTAINER contact@confluent.io

COPY control-center-docker.sh /usr/local/bin/

RUN ["chown", "-R", "confluent:confluent", "/etc/confluent-control-center", "/usr/local/bin/control-center-docker.sh"]
RUN ["chmod", "+x", "/usr/local/bin/control-center-docker.sh"]

EXPOSE 9021

USER confluent
CMD [ "/usr/local/bin/control-center-docker.sh" ]
