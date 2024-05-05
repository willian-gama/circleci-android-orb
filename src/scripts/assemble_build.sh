#!/bin/bash

COMMAND=assemble$BUILD_VARIANT
echo "$COMMAND"
./gradlew "$COMMAND"