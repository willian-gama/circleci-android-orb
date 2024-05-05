#!/bin/bash

COMMAND=ktlintCheck detekt lint"$BUILD_VARIANT"
echo "Running command: $COMMAND"
./gradlew "$COMMAND"