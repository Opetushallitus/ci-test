#!/bin/bash

# TRAVIS_BUILD_NUMBER="560"
# BUILD_ID="ci-$TRAVIS_BUILD_NUMBER"
# SERVICE="koulutusinformaatio-indeksoija"

echo "Checking if current build ${BUILD_ID} already exists in builds table"
RESPONSE=$(aws dynamodb get-item --table-name builds --key "{\"Service\": {\"S\": \"$SERVICE\"}, \"Build\": {\"S\": \"$BUILD_ID\"}}" --output json)
FOUND_ID=$(echo $RESPONSE|jq -r ".Item.Build.S")

if [[ $FOUND_ID == $BUILD_ID ]]; then
    echo "This seems to be a rebuild!"
    terminate_build
else
    echo "This seems to be a new build"
fi
