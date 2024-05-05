#!/bin/bash

COMMAND=verifyPaparazzi$BUILD_VARIANT
echo "Running command: $COMMAND"
./gradlew "$COMMAND"