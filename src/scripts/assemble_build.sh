#!/bin/bash

COMMAND=assemble$BUILD_VARIANT
echo "Running command: $COMMAND"
./gradlew "$COMMAND"