#!/bin/bash

: ${SCALA_VERSIONS:="2.10.5 2.11.7"}
: ${DEFAULT_SCALA_VERSION:="2.11.7"}
: ${CONFLUENT_PLATFORM_VERSION:="2.0.1"}
: ${DOCKER_BUILD_OPTS:="--rm=true "}
: ${DOCKER_TAG_OPTS:="-f "}
: ${PACKAGE_URL:="http://packages.confluent.io/archive/2.0"}

#PRIVATE_REPOSITORY=""
#PUSH_TO_DOCKER_HUB=