#!/bin/bash -e

set -o

# TRAVIS_BUILD_NUMBER="560"
# BUILD_ID="ci-$TRAVIS_BUILD_NUMBER"
# SERVICE="koulutusinformaatio-indeksoija"

SERVICE="ci-test"
BUILD_ID="ci-${TRAVIS_BUILD_NUMBER}"

echo "Checking if current build ${BUILD_ID} already exists in builds table"
PREVIOUS_BUILD=$(aws dynamodb get-item --table-name builds --key "{\"Service\": {\"S\": \"$SERVICE\"}, \"Build\": {\"S\": \"$BUILD_ID\"}}" --output json --region eu-west-1)
PREVIOUS_BUILD_ID=$(echo $RESPONSE|jq -r ".Item.Build.S")

if [[ $PREVIOUS_BUILD_ID == $BUILD_ID ]]; then
    echo "This seems to be a rebuild!"
    echo "Do NOT press the 'Restart build' button in Travis CI under a previous build."
    echo "Either push a new commit, or select 'Trigger build'."
    terminate_build
else
    echo "This seems to be a new build"
fi
