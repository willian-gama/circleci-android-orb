#!/bin/bash

COMMAND="ktlintCheck detekt lint$BUILD_VARIANT"
echo "Running command: $COMMAND"
# shellcheck disable=SC2086 # Do not expand gradle command intentionally because it has spaces.
./gradlew $COMMAND