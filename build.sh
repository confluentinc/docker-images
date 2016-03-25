#!/bin/bash

. settings.sh

if [ "$(uname)" = "Darwin" ]; then
  SHA1='shasum'
else
  SHA1='sha1sum'
fi


set -ex

if [ -z ${DOCKER_HOST+x} ];
then
  echo "DOCKER_HOST must be set before running this script.";
fi

TAGS=""

STAGING_DIRECTORY='./staging'

find "${STAGING_DIRECTORY}" -type d -maxdepth 1 -mindepth 1| xargs rm -rf

for SCALA_VERSION in ${SCALA_VERSIONS}; do
    echo "Building confluent-platform-${SCALA_VERSION}"

    DOCKER_FILE="confluent-platform/Dockerfile.${SCALA_VERSION}"

    cp confluent-platform/Dockerfile "$DOCKER_FILE"

    TAR_NAME="confluent-${CONFLUENT_PLATFORM_VERSION}-${SCALA_VERSION}"
    DOWNLOAD_TAR_URL="http://packages.confluent.io/archive/2.0/${TAR_NAME}.tar.gz"
    DOWNLOAD_TAR_PATH="${STAGING_DIRECTORY}/${TAR_NAME}.tar.gz"
    DOWNLOAD_CHECKSUM_PATH="${STAGING_DIRECTORY}/${TAR_NAME}.tar.gz.sha1.txt"
    curl -o "${DOWNLOAD_TAR_PATH}.sha1.txt" "${DOWNLOAD_TAR_URL}.sha1.txt"

    if [ ! -f $DOWNLOAD_TAR_PATH ];
    then
      curl -o "${DOWNLOAD_TAR_PATH}" "${DOWNLOAD_TAR_URL}"
    fi

    cd "${STAGING_DIRECTORY}"
    $SHA1 -c "${TAR_NAME}.tar.gz.sha1.txt"

    if [ $? -neq 0 ];
    then
      echo "Checksums for ${DOWNLOAD_TAR_PATH} do not match. Figure that out."
      exit 1
    fi

    cd $OLDPWD

    if [ ! -d "./${STAGING_DIRECTORY}/${TAR_NAME}" ];
    then
      mkdir "./${STAGING_DIRECTORY}/${TAR_NAME}"
    fi

    tar xzvf "./${STAGING_DIRECTORY}/${TAR_NAME}.tar.gz" -C "./${STAGING_DIRECTORY}/${TAR_NAME}"
    TAR_ROOT="$(find ${STAGING_DIRECTORY}/${TAR_NAME} -type d -maxdepth 1 -mindepth 1)"

    echo "ADD ${TAR_ROOT} /" >> "$DOCKER_FILE"

    TAG="confluent/platform-${SCALA_VERSION}:${CONFLUENT_PLATFORM_VERSION}"
    TAGS="${TAGS} ${TAG}"
    docker build $DOCKER_BUILD_OPTS -t $TAG -f "${DOCKER_FILE}" .
    docker tag -f "${TAG}" "confluent/platform-${SCALA_VERSION}:latest"

    if [ "x$SCALA_VERSION" = "x$DEFAULT_SCALA_VERSION" ]; then
      docker tag -f "${TAG}" "confluent/platform:latest"
      TAGS="${TAGS} confluent/platform:latest"
      docker tag -f "${TAG}" "confluent/platform:${CONFLUENT_PLATFORM_VERSION}"
      TAGS="${TAGS} confluent/platform:${CONFLUENT_PLATFORM_VERSION}"
    fi
done

IMAGES="zookeeper kafka schema-registry rest-proxy tools"

for IMAGE in ${IMAGES}; do
  docker build $DOCKER_BUILD_OPTS -t "confluent/${IMAGE}:${CONFLUENT_PLATFORM_VERSION}" "${IMAGE}/"
  TAGS="${TAGS} confluent/${IMAGE}:${CONFLUENT_PLATFORM_VERSION}"
  docker tag -f "confluent/${IMAGE}:${CONFLUENT_PLATFORM_VERSION}" "confluent/${IMAGE}:latest"
  TAGS="${TAGS} confluent/${IMAGE}:latest"
done

for TAG in ${TAGS}; do
  if [ "${PUSH_TO_DOCKER_HUB}" = "yes" ]; then
    docker push ${TAG}
  fi

  if [ "${PRIVATE_REPOSITORY}z" != "z" ];
  then
    docker tag -f "${TAG}" "${PRIVATE_REPOSITORY}/${TAG}"
    docker push "${PRIVATE_REPOSITORY}/${TAG}"
  fi
done
