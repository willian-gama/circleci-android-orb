#!/bin/bash

COMMAND=verifyPaparazzi"$BUILD_VARIANT"
echo "Running screenshot tests: $COMMAND"
./gradlew "$COMMAND"