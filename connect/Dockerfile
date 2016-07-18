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

COPY connect-docker.sh /usr/local/bin/

RUN ["mkdir", "-p", "/var/log/kafka"]
RUN ["chown", "-R", "confluent:confluent", "/var/log/kafka", "/etc/kafka", "/usr/local/bin/connect-docker.sh"]
RUN ["chmod", "+x", "/usr/local/bin/connect-docker.sh"]

EXPOSE 8083

USER confluent
CMD [ "/usr/local/bin/connect-docker.sh" ]
