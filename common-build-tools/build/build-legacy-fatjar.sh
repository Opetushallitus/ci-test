#!/bin/bash -e

export ARTIFACT_NAME=$1
export DOCKER_TARGET="$ECR_REPO/${ARTIFACT_NAME}:${TRAVIS_BUILD_NUMBER}"
export DOCKER_BUILD_DIR="/tmp/docker_build"

rm -rf ${DOCKER_BUILD_DIR}/target
mkdir -p ${DOCKER_BUILD_DIR}/target/config
mkdir -p ${DOCKER_BUILD_DIR}/target/wars
mkdir -p ${DOCKER_BUILD_DIR}/target/jars

cp common-build-tools/build/Dockerfile ${DOCKER_BUILD_DIR}/target/
cp common-build-tools/run/run-legacy-fatjar.sh ${DOCKER_BUILD_DIR}/target/run

sed -i -e "s|BASEIMAGE|${ECR_REPO}/${BASE_IMAGE}|g" ${DOCKER_BUILD_DIR}/target/Dockerfile

docker build --build-arg name=${ARTIFACT_NAME} -t ${DOCKER_TARGET} ${DOCKER_BUILD_DIR}/target
docker images
